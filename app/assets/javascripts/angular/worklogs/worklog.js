(function() {
  /*
   * decaffeinate suggestions:
   * DS001: Remove Babel/TypeScript constructor workaround
   * DS102: Remove unnecessary code created because of implicit returns
   * DS206: Consider reworking classes to avoid initClass
   * DS207: Consider shorter variations of null checks
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module('app');

  app.factory('Worklog', [
    'RailsResource',
    'Timeframe',
    'railsSerializer',
    'Client',
    'UiNotifier',
    function(RailsResource, Timeframe, railsSerializer, Client, UiNotifier) {
      class Worklog extends RailsResource {
        static initClass() {
          this.configure({
            url: '/worklogs', name: 'worklog', serializer: railsSerializer(function() {
              this.exclude('clients');
              this.exclude('client');
              this.exclude('loading');
              this.exclude('currency');
              this.exclude('errors');
              this.add('client_id', function(wl) {
                if (wl.client) {
                  return wl.client.id;
                } else {
                  return null;
                }
              });
              this.resource('client', 'Client');
              return this.resource('timeframes', 'Timeframe');
            }),
          });
        }

        constructor(opts) {
          {
            // Hack: trick Babel/TypeScript into allowing this before super.
            if (false) {
              super();
            }
            let thisFn = (() => {
              return this;
            }).toString();
            let thisName = thisFn.slice(thisFn.indexOf('return') + 6 + 1, thisFn.indexOf(';'))
              .trim();
            eval(`${thisName} = this;`);
          }
          if (opts == null) {
            opts = {};
          }
          const defaultOpts = {
            timeframes: [],
            clients: [],
            sharedClients: [],
            clientId: null,
            client: null,
            hourlyRate: 0,
            comment: '',
            id: null,
            loading: false,
            errors: [],
            total: 0,
            totalDuration: 0,
            notifier: new UiNotifier,
          };
          const _this = this;
          const useOpts = _.extend(defaultOpts, opts);
          _.each(useOpts, (val, key) => _this[key] = val);
        }

        addNewTimeframe(timeframe) {
          return this.timeframes.push(timeframe);
        }

        addBlankTimeframe() {
          const t = new Timeframe;
          if (this.timeframes.length) {
            const last_started = _.last(this.timeframes).started;
            if (last_started) {
              t.started = new Date(last_started);
              t.started.setSeconds(0, 0);
            } else {
              t.started = new Date;
              t.started.setSeconds(0, 0);
            }
            const last_ended = _.last(this.timeframes).ended;
            if (last_ended) {
              t.ended = new Date(last_ended);
              t.ended.setSeconds(0, 0);
            } else {
              t.ended = new Date;
              t.ended.setSeconds(0, 0);
            }
          } else {
            t.started = new Date;
            t.ended = new Date;
            t.started.setSeconds(0, 0);
            t.ended.setSeconds(0, 0);
          }
          return this.addNewTimeframe(t);
        }

        calcTotal() {
          const totals = _.map(this.timeframes, t => {
            const tTotal = t.calcTotal(this.secondlyRate());
            return tTotal;
          });
          return _.inject(totals, (memo, num) => memo + num
            , 0);
        }

        clientChanged() {
          this.hourlyRate = this.client ? this.client.hourlyRate : 0;
          return this.currency = this.client ? this.client.currency : undefined;
        }

        removeTimeframe(timeframe) {
          return this.timeframes = _.reject(this.timeframes, tf => tf === timeframe);
        }

        isNew() {
          return !this.id;
        }

        saveWrapper() {
          if (this.loading) {
            return;
          }
          // Reset all errors
          this.errors = [];
          this.loading = true;
          const callb = this.isNew() ? this.create() : this.save();
          const {timeframes} = this;
          const {clients} = this;
          const {client} = this;
          return callb.then(new_worklog => {
              this.loading = false;
              this.notifier.success('Worklog has been successfully saved.');
              return setTimeout(() => window.location.reload()
                , 200);
            }
            , error => {
              if (error.data) {
                this.errors = error.data;
              }
              return this.loading = false;
            });
        }

        applyDataFromWorklog(wl) {
          this.hourlyRate = wl.hourlyRate;
          this.clients = _.map(wl.clients, cl => new Client(cl));
          // Concat all shared clients
          const shared = _.map(wl.sharedClients, function(scl) {
            const c = new Client(scl);
            c.shared = true;
            return c;
          });
          this.clients = this.clients.concat(shared);

          this.clientId = wl.clientId;
          this.selectClientById();
          this.timeframes = _.map(wl.timeframes, function(tf) {
            const f = new Timeframe(tf);
            f.started = new Date(tf.started);
            f.ended = new Date(tf.ended);
            return f;
          });
          this.comment = wl.comment;
          this.id = wl.id;
          return this.total = wl.total;
        }

        secondlyRate() {
          return this.hourlyRate / 3600;
        }

        selectClientById() {
          const client = _.select(this.clients, cl => cl.id === this.clientId)[0];
          this.client = client;
          this.clientChanged();
          return this.client;
        }

        roundupTimeframes() {
          return _.each(this.timeframes, tf => {
            if (tf.ended) {
              tf.ended = this.roundDateUp(tf.ended);
            }
            if (tf.started) {
              return tf.started = this.roundDateDown(tf.started);
            }
          });
        }

        roundDateUp(date) {
          date = new Date(date);
          const coeff = 1000 * 60 * 5;
          return new Date(Math.ceil(date.getTime() / coeff) * coeff);
        }

        roundDateDown(date) {
          date = new Date(date);
          const coeff = 1000 * 60 * 5;
          return new Date(Math.floor(date.getTime() / coeff) * coeff);
        }

        creditBlocked() {
          return this.client && this.client.creditBlockReason &&
            this.client.creditBlockReason.length;
        }

        calcTotalDuration() {
          const durations = _.map(this.timeframes, tf => tf.durationSeconds());
          return _.inject(durations, (memo, num) => memo + num
            , 0);
        }
      }

      Worklog.initClass();

      return Worklog;
    },
  ]);
})();
