# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
#
# With no layout
# page '/*.xml', layout: false
# page '/*.json', layout: false
# page '/*.txt', layout: false

page '/', layout: 'default'

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# Activate and configure blog extension

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = 'posts'
  blog.layout = 'post'

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  # blog.tag_template = "tag.html"
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# page "/feed.xml", layout: false
# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

helpers do
  def find_author(author_slug)
    author_slug = author_slug.downcase
    result = data.authors.select { |author| author.keys.first == author_slug }

    raise ArgumentError unless result.any?

    result.first
  end

  def articles_by_author(author)
    sitemap.resources.select do |resource|
      resource.data.author == author.name
    end.sort_by { |resource| resource.data.date }
  end

  def author_path(author)
    "/authors/#{author.keys.first}"
  end

  def series_entries(series_slug)
    result = data.series.select { |series| series.keys.first == series_slug }

    result.first.try(:[], 'entries') || []
  end

  def strip_em(html)
    html.gsub("<em>", "").gsub("</em>", "")
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
activate :syntax
