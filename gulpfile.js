var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var del = require('del');
var autoprefixer = require('autoprefixer');
var shell = require('gulp-shell');

var _css_watch = [
  'html/themes/custom/ib3/src/sass/*.s+(a|c)ss',
  'html/modules/custom/**/sass/*.s+(a|c)ss'
];

var _css = [
  'html/themes/custom/ib3/src/sass/ib3.scss',
];

var _fonts = [
  'vendor/fortawesome/font-awesome/fonts/fontawesome-webfont.eot',
  'vendor/fortawesome/font-awesome/fonts/fontawesome-webfont.svg',
  'vendor/fortawesome/font-awesome/fonts/fontawesome-webfont.ttf',
  'vendor/fortawesome/font-awesome/fonts/fontawesome-webfont.woff',
  'vendor/fortawesome/font-awesome/fonts/fontawesome-webfont.woff2',
  'vendor/fortawesome/font-awesome/fonts/FontAwesome.otf'
];

var _js_watch = [
  'node_modules/jquery/dist/jquery.js',
  'node_modules/popper.js/dist/umd/popper.js',
  'node_modules/bootstrap/dist/js/bootstrap.js',
  'html/themes/custom/ib3/src/js/*.js',
  'html/modules/custom/**/js/*.js'
];

var _js = [
  'node_modules/jquery/dist/jquery.js',
  'node_modules/popper.js/dist/umd/popper.js',
  'node_modules/bootstrap/dist/js/bootstrap.js',
  'html/themes/custom/ib3/src/js/*.js'
];

/**
 * @task sass
 * Do sass stuff.
 */
gulp.task('sass', function () {
  var pcPlug = {
    autoprefixer: require('autoprefixer'),
    mqpacker: require('css-mqpacker')
  };
  var pcProcess = [
    pcPlug.autoprefixer({
      browsers: ['> 1%', 'last 2 versions', 'firefox >= 4', 'safari 7', 'safari 8', 'IE 8', 'IE 9', 'IE 10', 'IE 11']
    }),
    pcPlug.mqpacker()
  ];

  return gulp.src(_css)
  .pipe($.sourcemaps.init())
  .pipe($.sass())
  .on('error', function (err) {
    console.log(err);
    this.emit('end');
  })
  .pipe($.postcss(pcProcess))
  .pipe($.sourcemaps.write())
  .pipe(gulp.dest('html/themes/custom/ib3/static/css'));
});

/**
 * @task js
 * Do javascript stuff.
 */
gulp.task('js', function () {
  return gulp.src(_js)
  .pipe($.concat('ib3.js'))
  .pipe($.uglify())
  .pipe(gulp.dest('html/themes/custom/ib3/static/js'));
});

/**
 * @task clean
 * Clean the dist folder.
 */
gulp.task('clean', function () {
  return del([
    'html/themes/custom/ib3/static/css/*',
    'html/themes/custom/ib3/static/js/*',
    'html/themes/custom/ib3/static/fonts/*'
  ]);
});

gulp.task('fonts', function () {
  return gulp.src(_fonts)
  .pipe(gulp.dest('html/themes/custom/ib3/static/fonts'));
});

/**
 * @task cache
 * Clear the drupal cache.
 */
gulp.task('cache', shell.task([
  './vendor/bin/drupal cr all'
]));

/**
 * @task watch
 * Watch files and do stuff.
 */
gulp.task('watch', ['clean', 'sass', 'js', 'fonts', 'cache'], function () {
  gulp.watch(_css_watch, ['clean','sass','js','fonts','cache']);
  gulp.watch(_js_watch, ['clean','sass','js','fonts','cache']);
});

/**
 * @task default
 * Watch files and do stuff.
 */
gulp.task('default', ['watch']);
