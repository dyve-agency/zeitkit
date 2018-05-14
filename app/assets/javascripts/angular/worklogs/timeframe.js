(function() {
  /*
   * decaffeinate suggestions:
   * DS001: Remove Babel/TypeScript constructor workaround
   * DS102: Remove unnecessary code created because of implicit returns
   * DS206: Consider reworking classes to avoid initClass
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module("app");

  app.factory("Timeframe", [
    "RailsResource", "railsSerializer", function(RailsResource, railsSerializer) {
      class Timeframe extends RailsResource {
        static initClass() {
          this.configure({
            url: '/timeframes', name: 'timeframe', serializer: railsSerializer(function() {
              this.exclude("client");
              return this.resource("worklog", "Worklog");
            })
          });
        }

        constructor(opts) {
          super();
          const defaultOpts = {
            started: null,
            ended: null,
            client: null
          };
          const _this = this;
          const useOpts = _.extend(defaultOpts, opts);
          _.each(useOpts, (val, key) => _this[key] = val);
        }

        calcTotal(ratePerSecond) {
          if (ratePerSecond && this.started && this.ended) {
            return this.durationSeconds() * ratePerSecond;
          } else {
            return 0;
          }
        }

        _convertToMinutes(time) {
          if (typeof time === 'string')
            time = Date.parse(time);

          let x = new Date(time);

          return (time - x.setHours(0, 0, 0, 0)) / 1000 / 60;
        }

        get startedMinutes() {
          return this._convertToMinutes(this.started);
        }

        get endedMinutes() {
          return this._convertToMinutes(this.ended);
        }

        set startedMinutes(val) {
          this.started = new Date(new Date(this.started).setHours(0, 0, 0, 0) + val * 60 * 1000);
        }

        set endedMinutes(val) {
          this.ended = new Date(new Date(this.ended).setHours(0, 0, 0, 0) + val * 60 * 1000);
        }

        durationSeconds() {
          // For some reason the provided @ended and @started formats aren't working.
          // It's necessary to recreate a new Date, based on the dates provided.
          // Else the calculation causes a NaN
          return (((new Date(this.ended)) - (new Date(this.started))) / 1000);
        }

        setEndedNow() {
          return this.ended = new Date();
        }

        setStartedNow() {
          return this.started = new Date();
        }

        checkForIssues() {
          const issues = [];
          // TimeFrame more than 10 hours.
          const tenHours = 3600 * 10;
          if (this.started && this.ended && (this.durationSeconds() >= tenHours)) {
            issues.push("Duration is longer than 10 hours. Please double-check.");
          }
          if (this.started && this.ended && (this.durationSeconds() < 0)) {
            issues.push("Duration is smaller 0. Please check.");
          }
          return issues;
        }

        issueDetected() {
          return this.checkForIssues().length > 0;
        }
      }

      Timeframe.initClass();

      return Timeframe;
    }
  ]);
})();
