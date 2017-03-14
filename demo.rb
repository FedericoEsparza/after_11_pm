require './app'
require 'erb_latex'

ErbLatex.configure do | config |
  # config.file_extesion= '.tex' # defaults to .tex.erb
  config.verbose_logs = true    # will output failure diagnostics to STDERR when enabled
  config.xelatex_path = '/opt/texlive/bin/xelatex' # for cases where xelatex is not located in PATH
end

tmpl = ErbLatex::Template.new( 'document.tex', {
  partial_path: './',
  packages_path: '/location/of/custom/latex/packages',
  data: {
      author: "Nathan",
      messge: "Please call our department at 555-5555"
  }
})
tmpl.to_file('thank-you.pdf')
