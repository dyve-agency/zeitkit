(function() {
  /*
   * decaffeinate suggestions:
   * DS001: Remove Babel/TypeScript constructor workaround
   * DS102: Remove unnecessary code created because of implicit returns
   * DS206: Consider reworking classes to avoid initClass
   * DS207: Consider shorter variations of null checks
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module("app");

  app.factory("User", [
    "RailsResource", function(RailsResource) {
      class User extends RailsResource {
        static initClass() {
          this.configure({url: '/users', name: 'user'});
        }

        constructor(opts) {
          super();
          if (opts == null) {
            opts = {};
          }
          const defaultOpts =
            {username: ""};
          const _this = this;
          const useOpts = _.extend(defaultOpts, opts);
          _.each(useOpts, (val, key) => _this[key] = val);
        }

        usernameOrErrorString() {
          if (this.user.username.length) {
            return `${this.user.username}`;
          } else {
            return "No Username available";
          }
        }
      }

      User.initClass();
      return User;
    }
  ]);
})();
