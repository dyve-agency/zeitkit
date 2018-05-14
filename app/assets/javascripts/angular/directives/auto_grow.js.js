/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
/**
The MIT License (MIT)

Copyright (c) 2013 Thom Seddon
Copyright (c) 2010 Google

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Adapted from: http://code.google.com/p/gaequery/source/browse/trunk/src/static/scripts/jquery.autogrow-textarea.js

Works nicely with the following styles:
textarea {
resize: none;
word-wrap: break-word;
transition: 0.05s;
-moz-transition: 0.05s;
-webkit-transition: 0.05s;
-o-transition: 0.05s;
}

Usage: <textarea auto-grow></textarea>
*/

const app = angular.module("app");
app.directive("autoGrow", () =>
  function(scope, element, attr) {
    const minHeight = element[0].offsetHeight;
    const paddingLeft = element.css("paddingLeft");
    const paddingRight = element.css("paddingRight");
    const $shadow = angular.element("<div></div>").css({
      position: "absolute",
      top: -10000,
      left: -10000,
      width: element[0].offsetWidth - parseInt(paddingLeft || 0) - parseInt(paddingRight || 0),
      fontSize: element.css("fontSize"),
      fontFamily: element.css("fontFamily"),
      lineHeight: element.css("lineHeight"),
      resize: "none"
    });
    angular.element(document.body).append($shadow);
    const update = function() {
      const times = function(string, number) {
        let i = 0;
        let r = "";

        while (i < number) {
          r += string;
          i++;
        }
        return r;
      };

      const val = element.val().replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/&/g, "&amp;").replace(/\n$/, "<br/>&nbsp;").replace(/\n/g, "<br/>").replace(/\s{2,}/g, space => times("&nbsp;", space.length - 1) + " ");
      $shadow.html(val);
      element.css("height", Math.max($shadow[0].offsetHeight + 10, minHeight) + "px"); // the "threshold"
    };

    element.bind("keyup keydown keypress change", update);
    update();
  }
);

