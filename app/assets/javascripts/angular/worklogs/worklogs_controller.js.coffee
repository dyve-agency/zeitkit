app = angular.module("app")

app.controller "WorklogsController", ["$scope", "worklogData", ($scope, worklogData)->
  $scope.worklog = worklogData
]
