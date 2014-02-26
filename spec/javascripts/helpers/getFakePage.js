(function() {
  define(function() {
    var getFakePage;

    return getFakePage = function(thisPage) {
      var lastID, links, url, urls;

      if (thisPage == null) {
        thisPage = 1;
      }
      url = function(page) {
        return "/api/v1/context/2/resource?page=" + page + "&per_page=2";
      };
      lastID = thisPage * 2;
      urls = {
        current: url(thisPage),
        first: url(1),
        last: url(10)
      };
      links = ['<' + urls.current + '>; rel="current"'];
      if (thisPage < 10) {
        urls.next = url(thisPage + 1);
        links.push('<' + urls.next + '>; rel="next"');
      }
      if (thisPage > 1) {
        urls.prev = url(thisPage - 1);
        links.push('<' + urls.prev + '>; rel="prev"');
      }
      links.push('<' + urls.first + '>; rel="first"');
      links.push('<' + urls.last + '>; rel="last"');
      return {
        urls: urls,
        header: links.join(','),
        data: [
          {
            id: lastID - 1,
            foo: 'bar',
            baz: 'qux'
          }, {
            id: lastID,
            foo: 'bar',
            baz: 'qux'
          }
        ]
      };
    };
  });

}).call(this);
