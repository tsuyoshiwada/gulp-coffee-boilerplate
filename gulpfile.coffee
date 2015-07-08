gulp = require("gulp")
$ = do require("gulp-load-plugins")
del = require("del")
webpack = require("webpack")
browserSync = require("browser-sync").create()
runSequence = require("run-sequence")
minimist = require("minimist")


## Environment variables
knownOptions = 
  string: "env"
  default: 
    env: process.env.NODE_ENV || "development"

options = minimist(process.argv.slice(2), knownOptions)
global.isProduction = options.env == "production"
{isProduction} = global


# =======================================================
# $ gulp bs
# =======================================================
gulp.task("bs", (cb) ->
  browserSync.init({
    notify: false
    server: {
      baseDir: "dist"
    }
  })
  cb()
)


# =======================================================
# $ gulp bs:reload
# =======================================================
gulp.task("bs:reload", (cb) ->
  browserSync.reload()
  cb()
)


# =======================================================
# $ gulp clean
# =======================================================
gulp.task("clean", (cb) ->
  del([
    "dist"
  ], cb)
)


# =======================================================
# $ gulp copy-assets
# =======================================================
gulp.task("copy-assets", ->
  src = ["assets/**/*"]
  src.push("!assets/**/*.+(jpg|jpeg|png|gif|svg)") unless !isProduction

  gulp.src(src, base: "assets")
  .pipe(gulp.dest("dist"))
  .pipe(browserSync.stream())
)


# =======================================================
# $ gulp images
# =======================================================
gulp.task("images", ->
  gulp.src("assets/images/**/*.+(jpg|jpeg|png|gif|svg)")
  .pipe($.imagemin(
    optimizationLevel: 6
    progressive: true
    interlaced: true
    multipass: true
  ))
  .pipe(gulp.dest("dist/images"))
  .pipe(browserSync.stream())
)


# =======================================================
# $ gulp webpack
# =======================================================
gulp.task("webpack", (cb) ->
  webpack(require("./webpack.config.coffee"), (err, stats) ->
    if err
      throw new $.util.PluginError("webpack", err)

    $.util.log("[webpack]", stats.toString())

    browserSync.reload()
    cb()
  )
)


# =======================================================
# $ gulp uglify
# =======================================================
gulp.task("uglify", ->
  gulp.src("dist/js/**/*.js")
  .pipe($.uglify(preserveComments: "some"))
  .pipe(gulp.dest("dist/js"))
  .pipe(browserSync.stream())
)


# =======================================================
# $ gulp sass
# =======================================================
gulp.task("sass", ->
  if isProduction
    params = 
      outputStyle: "compressed"
  else
    params = 
      outputStyle: "expanded"

  gulp.src("src/sass/**/*.scss")
  .pipe($.plumber())
  .pipe($.sass.sync(params).on("error", $.sass.logError))
  .pipe($.autoprefixer(
    browsers: [
      "last 4 versions"
      "ie 9"
      "iOS 6"
      "Android 4"
    ]
  ))
  .pipe(gulp.dest("dist/css"))
  .pipe(browserSync.stream())
)


# =======================================================
# $ gulp build
# =======================================================
gulp.task("build", (cb) ->
  runSequence(
    "clean",
    "copy-assets",
    ["webpack", "sass"],
    ["uglify", "images"],
    cb
  )
)


# =======================================================
# $ gulp watch
# =======================================================
gulp.task("watch", (cb) ->
  runSequence(
    "build",
    "bs",
    ->
      $.watch("assets/**/*", ->
        gulp.start("copy-assets")
      )

      $.watch("src/coffee/**/*", ->
        gulp.start("webpack")
      )

      $.watch("src/sass/**/*", ->
        gulp.start("sass")
      )
      
      cb()
  )
)


# =======================================================
# $ gulp (start watch)
# =======================================================
gulp.task("default", ->
  gulp.start("watch")
)
