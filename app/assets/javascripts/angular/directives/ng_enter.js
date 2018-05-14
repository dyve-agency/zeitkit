(function() {
  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module('app');

  app.directive('ngEnter', () =>
    (scope, element, attrs) =>
      element.bind('keydown keypress', function(event) {
        if (event.which === 13) {
          scope.$apply(() => scope.$eval(attrs.ngEnter));
          return event.preventDefault();
        }
      }),
  );
}());
