require 'test_helper'
require 'modules/sync'
include Modules::Sync

class SyncModuleTest < ActiveSupport::TestCase

  test "sync_unicef_product should update existing product with aliases" do
    initial_size = Product.count

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "initialism": "ODK", "website": "https://opendatakit.org/"}')
    sync_unicef_product(new_product)

    assert_equal Product.count, initial_size
    
    saved_product = Product.find_by(slug: 'odk')
    assert_equal saved_product.website, "https://opendatakit.org/"
    assert_equal saved_product.aliases.length, 1
    assert_equal saved_product.aliases[0], 'Open Data Kit'
    assert_equal saved_product.slug, 'odk'

    not_saved_product = Product.find_by(slug: 'open_data_kit')
    assert_nil not_saved_product
  end

  test "sync_unicef_product should save new product with initialism" do
    initial_size = Product.count

    existing_product = products(:three)
    Product.delete existing_product

    assert_equal Product.count, initial_size - 1

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "initialism": "ODK", "website": "https://opendatakit.org/"}')
    sync_unicef_product(new_product)

    assert_equal Product.count, initial_size

    saved_product = Product.find_by(slug: 'open_data_kit')
    assert_equal saved_product.name, "Open Data Kit"
    assert_equal saved_product.slug, 'open_data_kit'
    assert_equal saved_product.website, "https://opendatakit.org/"
    assert_equal saved_product.aliases.length, 1
    assert_equal saved_product.aliases[0], 'ODK'

    not_saved_product = Product.find_by(slug: 'odk')
    assert_nil not_saved_product

    # Try syncing dupes with the same name.
    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "website": "https://opendatakit.org/"}')
    sync_unicef_product(new_product)

    assert_nil Product.find_by(slug: 'odk')
    assert_not_nil Product.find_by(slug: 'open_data_kit')
    assert_equal Product.count, initial_size

    # Try syncing dupes with the same name with one of the alias.
    new_product = JSON.parse('{"type": ["software"], "name": "ODK", "website": "https://opendatakit.org/"}')
    sync_unicef_product(new_product)

    assert_nil Product.find_by(slug: 'odk')
    assert_not_nil Product.find_by(slug: 'open_data_kit')
    assert_equal Product.count, initial_size

    # Try syncing dupes with the same initialism with one of the alias.
    new_product = JSON.parse('{"type": ["software"], "name": "OpenDataKit", "initialism": "ODK", "website": "https://opendatakit.org/"}')
    sync_unicef_product(new_product)

    assert_nil Product.find_by(slug: 'odk')
    saved_product = Product.find_by(slug: 'open_data_kit')
    assert_not_nil saved_product
    assert_equal saved_product.aliases.length, 2
    assert_equal saved_product.aliases[0], "ODK"
    assert_equal saved_product.aliases[1], "OpenDataKit"

    assert_equal Product.count, initial_size
  end

  test "update product website" do
    p1 = products(:one)
    p1.website = nil
    p1.save

    initial_size = Product.all.size

    p2 = JSON.parse('{ "name": "Product", "website": "www.foo.org"}')
    sync_osc_product(p2)

    # shouldn't create a duplicate
    assert_equal Product.all.size, initial_size
    p1 = Product.where(name: 'Product')[0]

    # website should be updated
    assert_equal p1.website, 'www.foo.org'
  end

  test "add product organizations" do
    p1 = products(:one)
    assert p1.organizations.empty?

    initial_size = Product.all.size

    p2 = JSON.parse('{ "name": "Product", "organizations": [ "Organization" ] }')
    sync_osc_product(p2)

    # shouldn't create a duplicate
    assert_equal Product.all.size, initial_size
    p1 = Product.where(name: 'Product')[0]

    # orgs should be updated
    assert_equal p1.organizations.size, 1
    assert_equal p1.organizations[0].name, 'Organization'

    # sync again, shouldn't add Org2 twice
    sync_osc_product(p2)
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.organizations.size, 1
    assert_equal p1.organizations[0].name, 'Organization'

    # sync again adding Org1, should be added and Org2 should still be there
    p2['organizations'] << 'Organization Again'
    sync_osc_product(p2)
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.organizations.size, 2
    assert p1.organizations.include? Organization.where(name: 'Organization Again')[0]
  end

  test "update product SDGs" do
    p1 = products(:one)
    assert p1.sustainable_development_goals.empty?

    initial_size = Product.all.size

    p2 = JSON.parse('{ "name": "Product", "SDGs": [ 7 ] }')
    sync_osc_product(p2)

    # shouldn't create a duplicate
    assert_equal Product.all.size, initial_size
    p1 = Product.where(name: 'Product')[0]

    # sdgs should be updated
    assert_equal p1.sustainable_development_goals.size, 1
    assert_equal p1.sustainable_development_goals[0].number, 7

    # sync again, shouldn't add sdg 7 twice
    sync_osc_product(p2)
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.sustainable_development_goals.size, 1
    assert_equal p1.sustainable_development_goals[0].number, 7

    # sync again adding Org1, should be added and Org2 should still be there
    p2['SDGs'] << 8
    sync_osc_product(p2)
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.sustainable_development_goals.size, 2
    assert p1.sustainable_development_goals.include? SustainableDevelopmentGoal.where(number: 8)[0]
  end

  test "create a new product" do
    initial_size = Product.all.size

    sync_osc_product(JSON.parse('{ "name": "OpenFOO"}'))
    assert_equal Product.all.size, initial_size + 1
  end

  test "ensure origin is set" do
    p1 = products(:one)
    assert p1.origins.empty?

    p2 = JSON.parse('{ "name": "Product" }')
    sync_osc_product(p2)

    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.origins[0].slug, 'dial_osc'
  end

  test "create assessment" do
    sync_osc_product(JSON.parse('{ "name": "Product", "maturity": { "cd10":true}}'))
    p1 = Product.where(name: 'Product')[0]
    assert_not_nil p1.product_assessment
    assert p1.product_assessment.has_osc
    assert p1.product_assessment.osc_cd10
  end

  test "overwrites things" do
    sync_osc_product(JSON.parse('{ "name":"Product", "website": "foo.org"}'))
    assert_equal Product.where(name: 'Product')[0].website, 'foo.org'
  end

end
