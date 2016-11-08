class BiasesController < ApplicationController
  def index
    render json: Bias.all
  end

  def crawl
    base = 'https://mediabiasfactcheck.com'

    biases = []

    %w(left leftcenter center right-center right pro-science conspiracy satire).each do |p|
      output = Wombat.crawl do
        base_url base
        path "/#{p}/"

        id({ xpath: '/html/body/@class' })
        name({ css: 'h1.entry-title' })
        description({ css: '.entry-content p:first-child' })
        url "#{base}/#{p}/"
      end
      output['id'] = /page-id-([0-9]+)/.match(output['id'])[1]
      output['description'] = output['description'].sub(/see also:/i, '').strip
      biases << output
    end

    Bias.delete_all
    biases.each do |b|
      Bias.create(b)
    end
  end
end
