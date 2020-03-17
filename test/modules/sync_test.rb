require 'test_helper'
require 'modules/sync'
include Modules::Sync

class SyncModuleTest < ActiveSupport::TestCase
  
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  test "sync_public_product should update product with aliases" do
    initial_size = Product.count

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "aliases": "ODK", "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_equal Product.count, initial_size

    saved_product = Product.find_by(slug: 'odk')
    assert_equal saved_product.website, "opendatakit.org"
    assert_equal saved_product.aliases.length, 1
    assert_equal saved_product.aliases[0], 'Open Data Kit'
    assert_equal saved_product.slug, 'odk'

    not_saved_product = Product.find_by(slug: 'open_data_kit')
    assert_nil not_saved_product
  end

  test "sync_public_product should update sdg for existing product" do
    initial_size = Product.count
    saved_product = Product.find_by(slug: 'odk')
    assert_equal saved_product.sustainable_development_goals.length, 0

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "aliases": "ODK", "SDGs": [7], "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_equal Product.count, initial_size

    saved_product = Product.find_by(slug: 'odk')
    assert_equal saved_product.sustainable_development_goals.size, 1

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "SDGs": [8], "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_equal Product.count, initial_size

    saved_product = Product.find_by(slug: 'odk')
    assert_equal saved_product.sustainable_development_goals.size, 2
  end

  test "sync_public_product should save product with alias" do
    initial_size = Product.count

    existing_assessment = product_assessments(:four)
    ProductAssessment.delete existing_assessment

    existing_product = products(:four)
    Product.delete existing_product

    assert_equal Product.count, initial_size - 1

    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "aliases": "ODK", "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_equal Product.count, initial_size

    saved_product = Product.find_by(slug: 'product_4')
    assert_equal saved_product.name, "Product 4"
    assert_equal saved_product.slug, 'product_4'
    assert_equal saved_product.website, "me.com"
    assert_equal saved_product.aliases.length, 1
    assert_equal saved_product.aliases[0], 'Prod 4'

    not_saved_product = Product.find_by(slug: 'prod_4')
    assert_nil not_saved_product

    # Try syncing dupes with the same name.
    new_product = JSON.parse('{"type": ["software"], "name": "Open Data Kit", "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_nil Product.find_by(slug: 'prod_4')
    assert_not_nil Product.find_by(slug: 'product_4')
    assert_equal Product.count, initial_size

    # Try syncing dupes with the same name with one of the alias.
    new_product = JSON.parse('{"type": ["software"], "name": "ODK", "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_nil Product.find_by(slug: 'prod_4')
    assert_not_nil Product.find_by(slug: 'product_4')
    assert_equal Product.count, initial_size

    # Try syncing dupes with the same initialism with one of the alias.
    new_product = JSON.parse('{"type": ["software"], "name": "OpenDataKit", "aliases": "ODK", "website": "https://opendatakit.org/"}')
    capture_stdout { sync_public_product(new_product) }

    assert_nil Product.find_by(slug: 'prod_4')
    saved_product = Product.find_by(slug: 'product_4')
    assert_not_nil saved_product
    assert_equal saved_product.aliases.length, 2
    assert_equal saved_product.aliases[0], "Prod 4"
    assert_equal saved_product.aliases[1], "Product4"

    assert_equal Product.count, initial_size
  end

  test "sync_digisquare_product should update existing product" do
    initial_size = Product.count
    assert_not_nil Product.find_by(slug: 'odk')

    new_product = JSON.parse('{"name": "ODK"}')
    capture_stdout { sync_digisquare_product(new_product) }

    assert_not_nil Product.find_by(slug: 'odk')
    assert_equal Product.count, initial_size
  end

  test "sync_digisquare_product should save new product" do
    initial_size = Product.count
    assert_nil Product.find_by(slug: 'open_data_kit')

    new_product = JSON.parse('{"name": "Open Data Kit"}')
    capture_stdout { sync_digisquare_product(new_product) }

    assert_not_nil Product.find_by(slug: 'open_data_kit')
    assert_equal Product.count, initial_size + 1
  end

  test "sync_osc_product should also search for dupes in aliases" do
    product = products(:one)
    product.aliases.push("Just Another Product Name")
    product.save

    initial_size = Product.count

    new_product_data = JSON.parse('{ "name": "Just Another Product Name", "website": "www.foo.org"}')
    capture_stdout { sync_osc_product(new_product_data) }

    assert_equal Product.count, initial_size
  end

  test "update product website" do
    p1 = products(:one)
    p1.website = nil
    p1.save

    initial_size = Product.all.size

    p2 = JSON.parse('{ "name": "Product", "website": "www.foo.org"}')
    capture_stdout { sync_osc_product(p2) }

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

    p2 = JSON.parse('{ "name": "Product", "organizations": [ {"name":"Organization" }] }')
    capture_stdout { sync_osc_product(p2) }

    # shouldn't create a duplicate
    assert_equal Product.all.size, initial_size
    p1 = Product.where(name: 'Product')[0]

    # orgs should be updated
    assert_equal p1.organizations.size, 1
    assert_equal p1.organizations[0].name, 'Organization'

    # sync again, shouldn't add Org2 twice
    capture_stdout { sync_osc_product(p2) }
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.organizations.size, 1
    assert_equal p1.organizations[0].name, 'Organization'

    # sync again adding Org1, should be added and Org2 should still be there
    p2 = JSON.parse('{ "name": "Product", "organizations": [ {"name":"Organization Again" }] }')
    capture_stdout { sync_osc_product(p2) }
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.organizations.size, 2
    assert p1.organizations.include? Organization.where(name: 'Organization Again')[0]
  end

  test "update product SDGs" do
    p1 = products(:one)
    assert p1.sustainable_development_goals.empty?

    initial_size = Product.all.size

    p2 = JSON.parse('{ "name": "Product", "SDGs": [ 7 ] }')
    capture_stdout { sync_osc_product(p2) }

    # shouldn't create a duplicate
    assert_equal Product.all.size, initial_size
    p1 = Product.where(name: 'Product')[0]

    # sdgs should be updated
    assert_equal p1.sustainable_development_goals.size, 1
    assert_equal p1.sustainable_development_goals[0].number, 7

    # sync again, shouldn't add sdg 7 twice
    capture_stdout { sync_osc_product(p2) }
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.sustainable_development_goals.size, 1
    assert_equal p1.sustainable_development_goals[0].number, 7

    # sync again adding Org1, should be added and Org2 should still be there
    p2['SDGs'] << 8
    capture_stdout { sync_osc_product(p2) }
    p1 = Product.where(name: 'Product')[0]
    assert_equal p1.sustainable_development_goals.size, 2
    assert p1.sustainable_development_goals.include? SustainableDevelopmentGoal.where(number: 8)[0]
  end

  test "create a new product" do
    initial_size = Product.all.size

    capture_stdout { sync_osc_product(JSON.parse('{ "name": "OpenFOO"}')) }
    assert_equal Product.all.size, initial_size + 1
  end

  test "ensure origin is set" do
    p1 = products(:four)
    assert p1.origins.empty?

    p2 = JSON.parse('{ "name": "Product 4" }')
    capture_stdout { sync_osc_product(p2) }

    p1 = Product.where(name: 'Product 4')[0]
    assert_equal p1.origins[0].slug, 'dial_osc'
  end

  test "create assessment" do
    capture_stdout { sync_osc_product(JSON.parse('{ "name": "Product", "maturity": { "cd10":true}}')) }
    p1 = Product.where(name: 'Product')[0]
    assert_not_nil p1.product_assessment
    assert p1.product_assessment.has_osc
    assert p1.product_assessment.osc_cd10
  end

  test "overwrites things" do
    capture_stdout { sync_osc_product(JSON.parse('{ "name":"Product", "website": "foo.org"}')) }
    assert_equal Product.where(name: 'Product')[0].website, 'foo.org'
  end
end
