(function() {
  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * DS207: Consider shorter variations of null checks
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  const app = angular.module("app");

  app.factory("UiNotifier", function() {
    class UiNotifier {
      success(text) {
        return $(".top-right").notify({
          message: {
            html: text
          },
          type: "success"
        }).show();
      }

      error(text) {
        return $(".top-right").notify({
          message: {
            html: text
          },
          type: "error"
        }).show();
      }

      hide() {
        return $(".top-right div")
          .css({transition: "opacity 0.3s"})
          .css({opacity: 0})
          .css({transition: ""});
      }

      render_error_array(arr, prefix_msg) {
        if (prefix_msg == null) {
          prefix_msg = "Folgende Fehler sind aufgetreten: ";
        }
        const error_html = window.App.Errors.arr_to_html(arr);
        const prefixed = `${prefix_msg}${error_html}`;
        return this.error(prefixed);
      }

      errors_or_fallback(data, fallback) {
        if (fallback == null) {
          fallback = "Ein unbekannter Fehler is aufgetreten";
        }
        if (data && data.errors) {
          return this.render_error_array(data.errors);
        } else {
          return this.error("Unbekannter Fehler beim Request aufgetreten.");
        }
      }

      errors_from_xhr(xhr, base_message) {
        let error_html = base_message;
        if (xhr && xhr.responseJSON && xhr.responseJSON.errors) {
          error_html += ` ${window.App.Errors.arr_to_html(xhr.responseJSON.errors)}`;
        }
        return error_html;
      }

      loading_message() {
        return this.success("<i class='icon-spinner icon-spin'></i> Lade...");
      }
    }

    return UiNotifier;
  });
})();
