host = 'https://railshotway.com'

xml.instruct!
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  xml.link href: "#{host}/feed.xml", rel: :self, type: 'application/atom+xml'
  xml.link href: "#{host}", rel: :alternate, type: 'text/html'
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.id "#{host}/feed.xml"
  xml.title 'Rails Hotway', type: :html
  xml.subtitle 'A blog about using Ruby on Rails and Hotwire to build amazing cross-platform applications'
  xml.author { xml.name 'Jose Farias and Avi Flombaum' }

  blog.articles.filter(&:published?).each do |post|
    url = "#{host}/#{post.path}"
    title = post.title

    xml.entry do
      xml.title title, type: :html
      xml.author { xml.name find_author(post.data['author'])['name'] }
      xml.link href: url, rel: :alternate, type: 'text/html', title: title
      xml.published post.date.to_time.iso8601
      xml.updated post.date.to_time.iso8601
      xml.id url
      xml.content post.body, type: :html, 'xml:base': url
      xml.media :thumbnail, 'xmlns:media': 'http://search.yahoo.com/mrss/', url: "#{host}/thumbnail.png"
      xml.media :content, 'xmlns:media': 'http://search.yahoo.com/mrss/', medium: :image, url: "#{host}/thumbnail.png"
    end
  end
end
