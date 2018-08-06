# frozen_string_literal: true

require 'bundler/gem_tasks'
# require 'rake/testtask'

# Rake::TestTask.new do |t|
#   t.libs << 'test'
#   t.test_files = FileList['test/**/*_test.rb']
#   t.verbose = false
#   t.warning = false
# end


def build_for_demo 
    `elm make elm/Main.elm --output assets/js/elm.js`
    `minify assets/js/elm.js assets/js/elm.min.js`
    FileUtil.cp "assets/js/elm.js" "../demo-elm-doc-builder/assets/js/elm.js"
    FileUtil.cp "assets/js/elm.min.js" "../demo-elm-doc-builder/assets/js/elm.min.js"
end