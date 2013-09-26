
module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-shell'

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json'),
        concat:
            js:
                src: [
                    #'node_modules/markdown/lib/markdown.js',
                    'node_modules/marked/lib/marked.js',
                    'static/js/*.js',
                    'dist/js/*.js'
                ],
                dest: 'dist/all.js'
            css:
                src: [
                    'dist/css/*.css'
                ],
                dest: 'dist/all.css'
            data:
                src: [
                    'static/data/*.md'
                ],
                dest: 'dist/all.md'
            final:
                src: [
                    'static/html/head1.html',
                    'dist/all.min.css',
                    'static/html/head2.html',
                    'dist/all.js',
                    'static/html/head3.html',

                    'static/html/markdown/head.html',
                    'dist/all.md',
                    'static/html/markdown/foot.html',

                    'static/html/body.html',
                    'static/html/foot.html'
                ],
                dest: 'dist/all.html'

        copy:
          main:
            files: [
              expand: true
              flatten: true
              src: ['static/img/*.png', 'static/img/*.jpg']
              dest: 'dist/img/'
              filter: 'isFile'
            ]

        cssmin:
            minify:
                files:
                    'dist/all.min.css': [
                        'dist/all.css'
                    ]

        uglify:
            minify:
                files:
                    'dist/all.min.js': [
                        'dist/all.js'
                    ]

        coffee:
            compile:
                files:
                    'dist/js/main.js': [
                      #'src/coffee/**/*.coffee'
                        'src/coffee/slidify.coffee',
                        'src/coffee/main.coffee'
                    ]

        compass:
            dist:
                options:
                    sassDir: 'src/scss'
                    cssDir: 'dist/css'

        shell:
            open:
                command: 'open ./dist/all.html'

    grunt.registerTask "default", [
        "coffee:compile",
        "compass:dist",

        "concat:js",
        "concat:css",
        "concat:data",

        "uglify:minify",
        "cssmin:minify",

        "concat:final",

        "copy:main",

        "shell:open"
    ]

