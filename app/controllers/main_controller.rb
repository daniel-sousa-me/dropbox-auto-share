#!/bin/env ruby
# encoding: utf-8

require "headless"
require "selenium-webdriver"

class MainController < ApplicationController
  # TODO: Store the folders somewhere (not in the code) and have a script to automatically update the list
  @@folders = [
    {:name => "1 – Primeiro Ano",
     :subfolders => [
       "[AL] Álgebra Linear",
       "[CCDI] Complementos de Cálculo Diferencial e Integral",
       "[CDI-I] Cálculo Diferencial e Integral I",
       "[CDI-II] Cálculo Diferencial e Integral II",
       "[EMF] Elementos de Matemática Finita",
       "[EPro] Elementos de Programação",
       "[IAlg] Introdução à Álgebra",
       "[IO] Introdução à Optimização",
       "[ME] Matemática Experimental",
       "[MO] Mecânica e Ondas",
     ]
    },
    {:name => "2 – Segundo Ano",
     :subfolders => [
       "[ACED] Análise Complexa e Equações Diferencias",
       "[CEO] Complementos de Electromagnetismo e Óptica",
       "[CPE] Complementos de Probabilidades e Estatística",
       "[EO] Electromagnetismo e Óptica",
       "[IG] Introdução à Geometria",
       "[LM] Lógica Matemática",
       "[LMC] Laboratório de Matemática Computacional",
       "[MC] Matemática Computacional",
       "[PEst] Probabilidades e Estatística",
       "[SM] Seminário de Matemática",
       "[TEM] Termodinâmica e Estrutura da Matéria",
     ]
    },
    {:name => "3 – Terceiro Ano",
     :subfolders => [
       "[AF] Análise Funcional",
       "[AMC] Algoritmos e Modelação Computacional",
       "[AML] Análise de Modelos Lineares",
       "[AN] Análise Numérica",
       "[ANEDP] Análise Numérica de Equações Diferenciais Parciais",
       "[ANFO] Análise Numérica Funcional e Optimização",
       "[AR] Análise Real",
       "[CAC] Análise Complexa",
       "[CTC] Combinatória e Teoria de Códigos",
       "[EDO] Equações Diferenciais Ordinárias",
       "[EDP] Equações Diferenciais Parciais",
       "[FA] Fundamentos de Álgebra",
       "[FCQ] Fiabilidade e Controlo de Qualidade",
       "[Ges] Gestão",
       "[GR] Geometria Riemanniana",
       "[ICC] Introdução à Computabilidade e Complexidade",
       "[IPE] Introdução aos Processos Estocásticos",
       "[PMat] Projecto em Matemática",
       "[SMon] Seminário e Monografia",
       "[SRCA] Superfícies de Riemann e Curvas Algébricas",
       "[Topo] Topologia",
     ]
    },
    #TODO: Adicionar MMA e DMat
    #{:name => "4 – [MMA] Mestrado Bolonha em Matemática e Aplicações",
    # :subfolders => [
    #   "v",
    # ]
    #},
    #{:name => "5 – [DMat] Programa Doutoral em Matemática",
    # :subfolders => [
    #   "v",
    # ]
    #},
    {:name => "6 – Cadeiras de Opção",
     :subfolders => [
       "[BD] Bases de Dados",
       "[CCD] Compressão e Codificação de Dados",
       "[GTD] Gestão e Teoria da Decisão",
       "[IArt] Inteligência Artificial",
       "[PSis] Programação de Sistemas",
       "[SAD] Sistemas de Apoio à Decisão",
     ]
    },
  ]
  
  def list
    @folders = @@folders
  end
  
  # TODO: Make this a delayed job
  def submit
    # TODO: Probably there's a better way of doing this
    app_config = YAML.load_file("#{Rails.root}/config/config.yml")
    
    folders_s = []
    @@folders.each_index do |i|
      folder = @@folders[i]
      folders_s_i = false
      folder[:subfolders].each_index do |j|
        if params[:post]["#{i}, #{j}"]=="1"
          unless folders_s_i
            folders_s_i = {:id=>i,:name=>folder[:name],:subfolders=>[]}
          end
          folders_s_i[:subfolders] << {:id=>j, :name=>folder[:subfolders][j]}
        end
      end
      if folders_s_i
        folders_s << folders_s_i
      end
    end
    
    headless = Headless.new
    headless.start
    
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "http://dropbox.com/login"
    
    driver.execute_script("document.getElementById('login_email').value = '#{app_config["DROPBOX_EMAIL"]}'")
    driver.execute_script("document.getElementById('login_password').value = '#{app_config["DROPBOX_PASSWORD"]}'")
    element_signin = driver.find_element(:id, 'login_submit')
    element_signin.click
    
    # FIXME: Remove the ugly sleeps
    folders_s.each do |folder|
      folder[:subfolders].each do |subfolder|
        driver.navigate.to "http://dropbox.com/home/LMAC/#{folder[:name]}/#{subfolder[:name]}"
        sleep 3
        share_button = driver.find_element(:id, 'global_share_button')
        share_button.click
        sleep 2
        email_input = driver.find_element(:id, 'sharing-options-new-collab-input')
        email_input.click
        driver.execute_script("document.getElementById('sharing-options-new-collab-input').value = '#{params[:post][:email]}'")
        send_button = driver.find_element(:id, 'share-invite-button')
        send_button.click
      end
    end
    
    driver.navigate.to "http://dropbox.com/logout"
    
    driver.quit
    headless.destroy
  end
end
