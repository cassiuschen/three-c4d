$ ->
  window.App = {}
  App.length = [$(window).height(), $(window).width()].sort (a,b) ->
    return (if a > b then 1 else -1)
  
  App.length = App.length[0]

  App.scene = new THREE.Scene()

  App.camera = new THREE.PerspectiveCamera(
    50, # 垂直从下到上的视觉角度（单位：度数）
    App.length/App.length, # 镜头高宽比，即 高度除以宽度
    1, # 近端的水平面裁剪
    5000 # 远端的水平面裁剪
  )

  # 定义渲染器
  App.renderer = new THREE.WebGLRenderer
    antialias:true
    alpha: false
  App.renderer.setClearColor(0x070709)
  App.renderer.shadowMapEnabled = true
  App.renderer.shadowMapSoft = true
  App.renderer.setSize( window.innerWidth, window.innerHeight );

  $('body').append App.renderer.domElement # 添加到页面
  App.light = new THREE.AmbientLight 0x404040
  #App.light.position.set( 0, 0, 0 )
  App.scene.add App.light

  lights = [];
  lights[0] = new THREE.PointLight( 0xffffff, 1, 0 )
  lights[1] = new THREE.PointLight( 0xffffff, 1, 0 )
  lights[2] = new THREE.PointLight( 0xffffff, 1, 0 )
  
  lights[0].position.set( 300, 300, 1000 )
  lights[1].position.set( 100, 100, 100 )
  lights[2].position.set( -100, -100, -100 )

  for light in lights
    App.scene.add light

  dLight = new THREE.DirectionalLight(0xffffff)
  dLight.position.set(1, 1000, 1)
  dLight.castShadow = true
  dLight.shadowCameraVisible = true
  dLight.shadowDarkness = 0.2
  dLight.shadowMapWidth = dLight.shadowMapHeight = 1000

  App.scene.add dLight

  #groundGeometry = new THREE.PlaneGeometry(1500, 1500, 1, 1)
  #App.ground = new THREE.Mesh groundGeometry, new THREE.MeshLambertMaterial(
  #    color: 0x101010
  #)
  #App.ground.position.y = -300
  #App.ground.rotation.x = - Math.PI / 2
  #App.ground.receiveShadow = true
  #App.scene.add App.ground
   
  # 定义几何体
  App.geometry = new THREE.BoxGeometry(
    250, # x轴对应面的宽度
    250, # y轴对应面的宽度
    250, # z轴对应面的宽度
    3, # x轴对应几何体表面切片数
    3, # y轴对应几何体表面切片数　
    3  # z轴对应几何体表面切片数
  )

  App.crateTexture = new THREE.TextureLoader()
  App.texture = App.crateTexture.load("./assets/images/texture.jpg")
   
  # 定义材质

  App.material = new THREE.MeshLambertMaterial
    map: App.texture
    wireframe: false
    wireframeLinewidth: 7
    color: 0x3388ff
    transparent: true
    opacity: 0.7
    emissive: 0x000000
    #wireframe: false
   
  # 生成正方形
  App.cube = new THREE.Mesh App.geometry
  App.cube.material = App.material
  App.cube.rotation.x = 0.5
  App.cube.rotation.y = 0.5
  
  App.cube.receiveShadow = true
  # 添加到场景中
  App.scene.add App.cube
   
  # 修改镜头位置
  App.camera.position.z = 1000


   


  App.render = ->
    requestAnimationFrame App.render
    App.cube.rotation.x += 0.00003
    App.cube.rotation.y += 0.00003
    App.renderer.render App.scene, App.camera
    App.camera.aspect = window.innerWidth / window.innerHeight
    App.camera.updateProjectionMatrix()

  App.rotation = (x,y) ->
    App.cube.rotation.x += x / 300
    App.cube.rotation.y += y / 300
    App.renderer.render App.scene, App.camera
    App.camera.aspect = window.innerWidth / window.innerHeight
    App.camera.updateProjectionMatrix()

  App.render()

  window.addEventListener 'resize', ->
      App.camera.aspect = window.innerWidth / window.innerHeight
      App.camera.updateProjectionMatrix()

      App.renderer.setSize window.innerWidth, window.innerHeight
      
  , false

  App.touch = {}
  touchStart = (e)->
    e.preventDefault()
    touch = e.touches[0]
    App.touch.x = touch.pageX
    App.touch.y = touch.pageY
    console.log App.touch

  touchMove = (e) ->
    e.preventDefault()
    touch = e.touches[0]
    App.rotation touch.pageX - App.touch.x, touch.pageY - App.touch.y


  $('canvas').on 'touchstart', (e) ->
    e.preventDefault()
    touch = e.originalEvent.touches[0]
    App.touch.x = touch.pageX
    App.touch.y = touch.pageY
    console.log App.touch

  $('canvas').on 'touchmove', (e) ->
    e.preventDefault()
    touch = e.originalEvent.touches[0]
    App.rotation touch.pageY - App.touch.y, touch.pageX - App.touch.x
    App.touch.x = touch.pageX
    App.touch.y = touch.pageY

