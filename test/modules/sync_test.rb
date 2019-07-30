require 'test_helper'
require 'modules/sync'
include Modules::Sync

class SyncModuleTest < ActiveSupport::TestCase

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
