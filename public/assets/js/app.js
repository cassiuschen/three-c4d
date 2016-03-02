$(function() {
  var dLight, i, len, light, lights, touchMove, touchStart;
  window.App = {};
  App.length = [$(window).height(), $(window).width()].sort(function(a, b) {
    return (a > b ? 1 : -1);
  });
  App.length = App.length[0];
  App.scene = new THREE.Scene();
  App.camera = new THREE.PerspectiveCamera(50, App.length / App.length, 1, 5000);
  App.renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: false
  });
  App.renderer.setClearColor(0x070709);
  App.renderer.shadowMapEnabled = true;
  App.renderer.shadowMapSoft = true;
  App.renderer.setSize(window.innerWidth, window.innerHeight);
  $('body').append(App.renderer.domElement);
  App.light = new THREE.AmbientLight(0x404040);
  App.scene.add(App.light);
  lights = [];
  lights[0] = new THREE.PointLight(0xffffff, 1, 0);
  lights[1] = new THREE.PointLight(0xffffff, 1, 0);
  lights[2] = new THREE.PointLight(0xffffff, 1, 0);
  lights[0].position.set(300, 300, 1000);
  lights[1].position.set(100, 100, 100);
  lights[2].position.set(-100, -100, -100);
  for (i = 0, len = lights.length; i < len; i++) {
    light = lights[i];
    App.scene.add(light);
  }
  dLight = new THREE.DirectionalLight(0xffffff);
  dLight.position.set(1, 1000, 1);
  dLight.castShadow = true;
  dLight.shadowCameraVisible = true;
  dLight.shadowDarkness = 0.2;
  dLight.shadowMapWidth = dLight.shadowMapHeight = 1000;
  App.scene.add(dLight);
  App.geometry = new THREE.BoxGeometry(250, 250, 250, 3, 3, 3);
  App.crateTexture = new THREE.TextureLoader();
  App.texture = App.crateTexture.load("./assets/images/texture.jpg");
  App.material = new THREE.MeshLambertMaterial({
    map: App.texture,
    wireframe: false,
    wireframeLinewidth: 7,
    color: 0x3388ff,
    transparent: true,
    opacity: 0.7,
    emissive: 0x000000
  });
  App.cube = new THREE.Mesh(App.geometry);
  App.cube.material = App.material;
  App.cube.rotation.x = 0.5;
  App.cube.rotation.y = 0.5;
  App.cube.receiveShadow = true;
  App.scene.add(App.cube);
  App.camera.position.z = 1000;
  App.render = function() {
    requestAnimationFrame(App.render);
    App.cube.rotation.x += 0.00003;
    App.cube.rotation.y += 0.00003;
    App.renderer.render(App.scene, App.camera);
    App.camera.aspect = window.innerWidth / window.innerHeight;
    return App.camera.updateProjectionMatrix();
  };
  App.rotation = function(x, y) {
    App.cube.rotation.x += x / 300;
    App.cube.rotation.y += y / 300;
    App.renderer.render(App.scene, App.camera);
    App.camera.aspect = window.innerWidth / window.innerHeight;
    return App.camera.updateProjectionMatrix();
  };
  App.render();
  window.addEventListener('resize', function() {
    App.camera.aspect = window.innerWidth / window.innerHeight;
    App.camera.updateProjectionMatrix();
    return App.renderer.setSize(window.innerWidth, window.innerHeight);
  }, false);
  App.touch = {};
  touchStart = function(e) {
    var touch;
    e.preventDefault();
    touch = e.touches[0];
    App.touch.x = touch.pageX;
    App.touch.y = touch.pageY;
    return console.log(App.touch);
  };
  touchMove = function(e) {
    var touch;
    e.preventDefault();
    touch = e.touches[0];
    return App.rotation(touch.pageX - App.touch.x, touch.pageY - App.touch.y);
  };
  $('canvas').on('touchstart', function(e) {
    var touch;
    e.preventDefault();
    touch = e.originalEvent.touches[0];
    App.touch.x = touch.pageX;
    App.touch.y = touch.pageY;
    return console.log(App.touch);
  });
  return $('canvas').on('touchmove', function(e) {
    var touch;
    e.preventDefault();
    touch = e.originalEvent.touches[0];
    App.rotation(touch.pageY - App.touch.y, touch.pageX - App.touch.x);
    App.touch.x = touch.pageX;
    return App.touch.y = touch.pageY;
  });
});
