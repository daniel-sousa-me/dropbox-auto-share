#!/bin/env ruby
# encoding: utf-8

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
       "[AC] Análise Complexa",
       "[AF] Análise Funcional",
       "[AMC] Algoritmos e Modelação Computacional",
       "[AML] Análise de Modelos Lineares",
       "[AN] Análise Numérica",
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
    {:name => "4 – [MMA] Mestrado Bolonha em Matemática e Aplicações",
     :subfolders => [
       "[AAva] Algoritmos Avançados",
       "[AEDis] Algoritmos em Estruturas Discretas",
       "[AM] Análise Multivariada",
       "[ANEDP] Análise Numérica de Equações Diferenciais Parciais",
       "[CA] Complementos de Álgebra",
       "[CC] Computabilidade e Complexidade",
       "[CPS] Criptografia e Protocolos de Segurança",
       "[DVS] Desenvolvimento e Verificação de Software",
       "[EB] Estatística Biomédica",
       "[EMat] Estatística Matemática",
       "[FLTC] Fundamentos de Lógica e Teoria da Computação",
       "[FTAR] Fundamentos de Topologia e Análise Real",
       "[GDif] Geometria Diferencial",
       "[GRen] Grupo de Renormalização",
       "[IMF] Introdução a Matematica Financeira",
       "[LVM] Lógica e Verificação de Modelos",
       "[MEDM] Métodos Estatísticos em Data Mining",
       "[MG] Mecânica Geométrica",
       "[MMA] Modelação Matemática e Aplicações",
       "[MMB] Modelos Matemáticos em Biomedicina",
       "[PIMA] Projecto de Investigação em Matemática e Aplicações",
       "[PMMate] Projecto em Modelação Matemática",
       "[RMate] Relatividade Matemática",
       "[TAlg] Topologia Algébrica",
       "[TP] Teoria da Probabilidade",
       "[TSD] Teoria de Sistemas Dinâmicos",
     ]
    },
    {:name => "5 – [DMat] Programa Doutoral em Matemática",
     :subfolders => [
       "[AComu] Álgebra Comutativa",
       "[AHar] Análise Harmónica",
       "[ANEI] Análise Numérica de Equações Integrais",
       "[AOpe] Álgebras de Operadores",
       "[AProb] Algoritmos Probabilísticos",
       "[CCA] Computabilidade e Complexidade da Aprendizagem",
       "[CEsto] Cálculo Estocástico",
       "[CILQ] Computação, Informação e Lógica Quânticas",
       "[CK] Complexidade de Kolmogorov",
       "[CVEDP] Cálculo de Variações e Equações Diferenciais Parciais",
       "[EDPE] Equações Diferenciais Parciais de Evolução",
       "[EFA] Elementos de Fronteira e Aplicações",
       "[GAlg] Geometria Algébrica",
       "[GLAL] Grupos de Lie e Álgebras de Lie",
       "[GS] Geometria Simpléctica",
       "[IFAMQ] Integração Funcional e Aplicações à Mecânica Quântica",
       "[LCle] Lógica Cleística",
       "[LFTD] Lógica Funcional e Teoria da Demonstração",
       "[LMod] Lógica Modal",
       "[MCA] Geometria e Teoria de Gauge",
       "[MMNMF] Métodos Matemáticos e Numéricos em Mecânica dos Fluidos",
       "[MMPE] Métodos Matemáticos em Problemas de Engenharia",
       "[MNEDO] Métodos Numéricos para Equações Diferenciais Ordinárias",
       "[NPC] Novos Paradigmas da Computação",
       "[OCVCO] Optimização, Cálculo de Variações e Controlo Óptimo",
       "[PIEDIM] Problemas Inversos em Equações Diferenciais e Imagiologia Médica",
       "[SDD] Sistemas Dinâmicos Discretos",
       "[SDDI] Sistemas Dinâmicos de Dimensão Infinita",
       "[SIM] Seminário de Investigação em Matemática",
       "[TAAM] Tópicos Avançados de Análise Multivariada",
       "[TAAN] Tópicos de Análise Aplicada e Numérica",
       "[TAIE] Tópicos Avançados de Inferência Estatística",
       "[TAO] Tópicos de Álgebras de Operadores",
       "[TAPPE] Tópicos Avançados de Probabilidades e Processos Estocásticos",
       "[TASI-I] Tópicos Avançados em Segurança de Informação I",
       "[TBED] Teoria de Bifurcação em Equações Diferenciais",
       "[TCat] Teoria das Categorias",
       "[TCCon] Teoria do Campo Conforme",
       "[TCor] Teoria de Cordas",
       "[TD] Topologia Diferencial",
       "[TEDH] Teoria Ergódica e Dinâmica Hiperbólica",
       "[TEDSD] Tópicos de Equações Diferenciais e Sistemas Dinâmicos",
       "[TH] Teoria da Homotopia",
       "[Tos] Teoria dos Nós",
       "[TTO] Tópicos de Teoria de Operadores",
     ]
    },
    {:name => "6 – Cadeiras de Opção",
     :subfolders => [
       "[AAut] Aprendizagem Automática",
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
  
  def submit
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
    
    MainHelper.delay.browser_stuff folders_s, params[:post][:email]
  end
  
end
