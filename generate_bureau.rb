require 'prawn'
require 'yaml'
require 'fileutils'

def draw_address(address, address_position)
  draw_text address["escalier"], :size => 12, :at => [38, address_position + 44]
  draw_text address["batiment"], :size => 12, :at => [38 + 107, address_position + 44]
  draw_text address["numero"], :size => 12, :at => [38, address_position + 22]
  draw_text address["extension"], :size => 12, :at => [38 + 42, address_position +22]
  draw_text address["type"], :size => 12, :at => [38 + 107, address_position + 22]
  draw_text address["nom"], :size => 12, :at => [38 + 172, address_position + 22]
  draw_text address["BP"], :size => 12, :at => [38, address_position]
  draw_text address["code"], :size => 12, :at => [38 + 107, address_position]
  draw_text address["ville"], :size => 12, :at => [38 + 172, address_position]
end

def draw_member(member, position)
  draw_text member["fonction"], :size => 14, :at => [335, position + 147]

  case member["sex"] 
    when "M"
      cross = 185
    when "Mlle"
      cross = 133
    when "Mme"
      cross = 81
  end
  draw_text "X", :size => 14, :at => [cross, position + 121]

  draw_text member["nom"], :size => 14, :at => [75, position + 105]
  draw_text member["prenom"], :size => 14, :at => [300, position + 105]
  draw_text member["nationalite"], :size => 14, :at => [99, position + 88]
  draw_text member["profession"], :size => 14, :at => [260, position + 88]
  draw_address(member["addresse"], position)
end

filename = "data/pdfs/formulaire_dirigeants.pdf"

if !File.exist?("bureau.yml")
  p "please copy bureau.yml.sample to bureau.yml, and configure it"
  exit
end

settings = YAML::load( File.open( 'bureau.yml' ) )
FileUtils.mkdir "output"

Prawn::Document.generate("output/bureau.pdf", :template => filename) do

  identification = settings["identification"]

  draw_text identification["titre"], :size => 16, :at => [230, 497]
  draw_text identification["dossier"], :size => 14, :at => [160, 430]
  draw_text identification["siren"], :size => 14, :at => [290, 394]

  draw_address(identification["addresse"], 302)

  draw_text Time.now.strftime("%d/%m/%Y"), :size => 14, :at => [390, 178]

  draw_text Time.now.strftime("%d/%m/%Y"), :size => 14, :at => [145, 108]
  draw_text identification["declaration"], :size => 14, :at => [290, 108]

  go_to_page 2

  draw_text identification["titre"], :size => 16, :at => [150, 713]
  draw_text identification["dossier"], :size => 14, :at => [220, 657]

  draw_member(settings["membre1"], 478)
  draw_member(settings["membre2"], 292)

end
