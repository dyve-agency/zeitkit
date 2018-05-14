function() {
  /*
   * decaffeinate suggestions:
   * DS001: Remove Babel/TypeScript constructor workaround
   * DS102: Remove unnecessary code created because of implicit returns
   * DS206: Consider reworking classes to avoid initClass
   * DS207: Consider shorter variations of null checks
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module("app");

  app.factory("Client", ["RailsResource", function(RailsResource){
    class Client extends RailsResource {
      static initClass() {
        this.configure({url: '/clients', name: 'client'});
      }
      constructor(opts){
        {
          // Hack: trick Babel/TypeScript into allowing this before super.
          if (false) { super(); }
          let thisFn = (() => { return this; }).toString();
          let thisName = thisFn.slice(thisFn.indexOf('return') + 6 + 1, thisFn.indexOf(';')).trim();
          eval(`${thisName} = this;`);
        }
        if (opts == null) { opts = {}; }
        const defaultOpts = {
          hourly_rate_cents: 0,
          shared: false,
          companyName: "",
          name: ""
        };
        const _this = this;
        const useOpts = _.extend(defaultOpts, opts);
        _.each(useOpts, (val, key) => _this[key] = val);
      }

      nameOrCompanyName() {
        if (this.name.length) {
          return `${this.name} [${this.user.username}]`;
        } else {
          return `${this.companyName} [${this.user.username}]`;
        }
      }
    }
    Client.initClass();
    return Client;
  }
  ]);
}();
