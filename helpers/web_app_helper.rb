module WebAppHelper
  def gen_worksheets_sheets(params)
    temp_param = { options: {single_var_qs: [params['options']['single_var_qs'].first.to_i, params['options']['single_var_qs'].last]} }
    gen = WorksheetGenerator.new().generate_worksheet(temp_param).file
    gen.each do |path|
      name = path[/(?![\.\/temp\/]).+\.tex/].chomp('.tex')
      system("pdflatex #{path.to_s} >/dev/null")
      system("rm #{name}.aux")
      system("rm #{name}.log")
      # system("rm #{path}")
      system("mv #{name}.pdf ./temp/")
    end
    gen.map { |link| link.to_s.chomp('.tex') + '.pdf'}
  end
end
