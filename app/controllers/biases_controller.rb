class BiasesController < ApplicationController
  def index
    render json: Bias.all
  end

  def show
    render json: Bias.find(params[:id])
  end

  def slug
    render json: Bias.find_by(slug: params[:slug])
  end

  def crawl
    base = 'https://mediabiasfactcheck.com'

    biases = []

    %w(left leftcenter center right-center right pro-science conspiracy satire).each do |p|
      biases << Wombat.crawl do
        base_url base
        path "/#{p}/"

        id({ xpath: '/html/body/@class' }) do |i|
          /page-id-([0-9]+)/.match(i)[1]
        end
        name({ css: '.page > .entry-header h1.entry-title' })
        description({ css: '.entry-content p:first-child' }) do |d|
          d.sub(/see also:/i, '').strip
        end
        url "#{base}/#{p}/"
        slug p
      end
    end

    Bias.delete_all
    biases.each do |b|
      Bias.create(b)
    end

    head :ok
  end
end
