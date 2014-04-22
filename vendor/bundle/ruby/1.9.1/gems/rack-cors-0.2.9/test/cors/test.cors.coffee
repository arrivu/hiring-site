CORS_SERVER = 'cors-server:3000'

describe 'CORS', ->

  it 'should allow access to dynamic resource', (done) ->
    $.get "http://#{CORS_SERVER}/", (data, status, xhr) ->
      expect(data).to.eql('Hello world')
      done()

  it 'should allow access to static resource', (done) ->
    $.get "http://#{CORS_SERVER}/static.txt", (data, status, xhr) ->
      expect($.trim(data)).to.eql("hello world")
      done()

  it 'should allow post resource', (done) ->
    $.ajax
      type: 'POST'
      url: "http://#{CORS_SERVER}/cors"
      beforeSend: (xhr) -> xhr.setRequestHeader('X-Requested-With', 'XMLHTTPRequest')
      success:(data, status, xhr) ->
        expect($.trim(data)).to.eql("OK!")
        done()

