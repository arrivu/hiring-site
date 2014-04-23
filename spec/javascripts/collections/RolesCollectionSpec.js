(function() {
  define(['Backbone', 'underscore', 'compiled/models/Role', 'compiled/collections/RolesCollection', 'compiled/util/BaseRoleTypes'], function(Backbone, _, Role, RolesCollection) {
    module('RolesCollection', {
      setup: function() {
        return this.account_id = 2;
      },
      teardown: function() {
        return this.account_id = null;
      }
    });
    test("generate the correct url for a collection of roles", 1, function() {
      var roles_collection;

      roles_collection = new RolesCollection(null, {
        contextAssetString: "account_" + this.account_id
      });
      return equal(roles_collection.url(), "/api/v1/accounts/" + this.account_id + "/roles", "roles collection url");
    });
    test("fetches a collection of roles", 1, function() {
      var role1, role2, roles_collection, server,
        _this = this;

      server = sinon.fakeServer.create();
      role1 = new Role;
      role2 = new Role;
      roles_collection = new RolesCollection(null, {
        contextAssetString: "account_" + this.account_id
      });
      roles_collection.fetch({
        success: function() {
          return equal(roles_collection.size(), 2, "Adds all of the roles to the collection");
        }
      });
      server.respond('GET', roles_collection.url(), [
        200, {
          'Content-Type': 'application/json'
        }, JSON.stringify([role1, role2])
      ]);
      return server.restore();
    });
    return test("keeps roles in order based on sort order then alphabetically", function() {
      var roleCollection, roleFirst, roleFith, roleFourth, roleSecond, roleThird;

      RolesCollection.sortOrder = ["AccountMembership", "StudentEnrollment", "TaEnrollment"];
      roleFirst = new Role({
        base_role_type: "AccountMembership",
        role: 'AccountAdmin'
      });
      roleSecond = new Role({
        base_role_type: "AccountMembership",
        role: 'Another account membership'
      });
      roleThird = new Role({
        base_role_type: "StudentEnrollment",
        role: 'A student Role'
      });
      roleFourth = new Role({
        base_role_type: "StudentEnrollment",
        role: 'B student Role'
      });
      roleFith = new Role({
        base_role_type: "TaEnrollment",
        role: 'A TA role'
      });
      roleCollection = new RolesCollection([roleThird, roleSecond, roleFirst, roleFourth, roleFith]);
      equal(roleCollection.models[0], roleFirst, "First role is in order");
      equal(roleCollection.models[1], roleSecond, "Second role is in order");
      equal(roleCollection.models[2], roleThird, "Third role is in order");
      equal(roleCollection.models[3], roleFourth, "Forth role is in order");
      return equal(roleCollection.models[4], roleFith, "Fith role is in order");
    });
  });

}).call(this);
