module Etag
  def get_with_etag(uri)
    Timecop.travel 1.second.from_now
    @etags ||= {}

    if etag = @etags[uri]
      get uri, {}, 'HTTP_IF_NONE_MATCH' => etag
    else
      get uri
      @etags[uri] = page.response_headers['Etag']
    end
  end
end

World Etag
