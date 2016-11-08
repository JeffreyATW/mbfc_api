class SourcesController < ApplicationController
  def index
    render json: Source.all
  end

  def show
    render json: Source.find(params[:id])
  end

  def domain
    render json: Source.find_by(domain: params[:domain])
  end

  def crawl
    sources = []

    Bias.all.each do |b|
      url_crawls = []
      uri = URI(b.url)

      url_crawls << Wombat.crawl do
        base_url "#{uri.scheme}://#{uri.host}"
        path uri.path

        urls 'xpath=//*/div[@class="entry-content"]//p[position()=2]/a/@href', :list
      end

      url_crawls.each do |c|
        c['urls'].each do |u|
          uri = URI(u)
          
          source = Wombat.crawl do
            base_url "#{uri.scheme}://#{uri.host}"
            path uri.path

            id({ xpath: '/html/body/@class' }) do |i|
              /page-id-([0-9]+)/.match(i)[1]
            end
            name({ css: '.page > .entry-header h1.entry-title' })
            notes({ xpath: '//*[text()[contains(.,"Notes:")]]' }) do |n|
              n.nil? ? '' : n.sub(/notes:/i, '').strip
            end
            homepage({ xpath: '//*[text()[contains(.,"Source:")]]/a/@href'})
            domain({ xpath: '//*[text()[contains(.,"Source:")]]/a/@href'}) do |d|
              d.nil? ? '' : URI(d).host.sub(/^www\./, '')
            end
            url "#{uri.scheme}://#{uri.host}#{uri.path}"
          end

          source['bias'] = b

          sources << source
        end
      end
    end

    Source.delete_all
    sources.each do |s|
      unless s['domain'] == ''
        begin
          Source.create(s)
        rescue ActiveRecord::RecordNotUnique
        end
      end
    end

    head :ok
  end
end
