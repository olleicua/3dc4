if ( ! Detector.webgl ) Detector.addGetWebGLMessage();
var camera, controls, scene, renderer;
init();
render(); // remove when using next line for animation loop (requestAnimationFrame)
//animate();
function init() {
	scene = new THREE.Scene();
	scene.background = new THREE.Color( 0xcccccc );
	scene.fog = new THREE.FogExp2( 0xcccccc, 0.002 );
	renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth, window.innerHeight );
	var container = document.getElementById( 'container' );
	container.appendChild( renderer.domElement );
	camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 1000 );
	camera.position.z = 500;
	controls = new THREE.OrbitControls( camera, renderer.domElement );
	controls.addEventListener( 'change', render ); // remove when using animation loop
	// enable animation loop when using damping or autorotation
	//controls.enableDamping = true;
	//controls.dampingFactor = 0.25;
	controls.enableZoom = false;
	// world
  var objects = [];
	var geometry = new THREE.BoxGeometry( 30, 10, 30 );
	for ( var x = 0; x < 4; x ++ ) {
  	for ( var y = 0; y < 4; y ++ ) {
    	for ( var z = 0; z < 4; z ++ ) {
      	var material = new THREE.MeshPhongMaterial( { color: 0xffffff, flatShading: true } );
    		var mesh = new THREE.Mesh( geometry, material );
    		mesh.position.x = (x * 50) - 90;
    		mesh.position.y = (y * 50) - 90;
    		mesh.position.z = (z * 50) - 90;
    		mesh.updateMatrix();
    		mesh.matrixAutoUpdate = false;
    		scene.add( mesh );
        objects.push(mesh);
      }
    }
	}
	// lights
	var light = new THREE.DirectionalLight( 0xffffff );
	light.position.set( 1, 1, 1 );
	scene.add( light );
	var light = new THREE.DirectionalLight( 0x002288 );
	light.position.set( -1, -1, -1 );
	scene.add( light );
	var light = new THREE.AmbientLight( 0x222222 );
	scene.add( light );
	//
	//
	window.addEventListener( 'resize', onWindowResize, false );


  var raycaster = new THREE.Raycaster();
  var mouse = new THREE.Vector2();
  function onDocumentTouchEnd( event ) {
  	event.preventDefault();
  	event.clientX = event.touches[0].clientX;
  	event.clientY = event.touches[0].clientY;
  	onDocumentMouseDown( event );
  }
  function onDocumentMouseUp( event ) {
  	event.preventDefault();
  	mouse.x = ( event.clientX / renderer.domElement.clientWidth ) * 2 - 1;
  	mouse.y = - ( event.clientY / renderer.domElement.clientHeight ) * 2 + 1;
  	raycaster.setFromCamera( mouse, camera );
  	var intersects = raycaster.intersectObjects( objects );
  	if ( intersects.length > 0 ) {
      console.log(intersects[ 0 ])
  		intersects[ 0 ].object.material.color.setHex( Math.random() * 0xffffff );
      render();
  		//var particle = new THREE.Sprite( particleMaterial );
  		//particle.position.copy( intersects[ 0 ].point );
  		//particle.scale.x = particle.scale.y = 16;
  		//scene.add( particle );
  	}
  	/*
  	// Parse all the faces
  	for ( var i in intersects ) {
  		intersects[ i ].face.material[ 0 ].color.setHex( Math.random() * 0xffffff | 0x80000000 );
  	}
  	*/
  }

  document.addEventListener( 'mouseup', onDocumentMouseUp, false );
  document.addEventListener( 'touchend', onDocumentTouchEnd, false );
}
function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();
	renderer.setSize( window.innerWidth, window.innerHeight );
}
function animate() {
	requestAnimationFrame( animate );
	controls.update(); // required if controls.enableDamping = true, or if controls.autoRotate = true
	render();
}
function render() {
	renderer.render( scene, camera );
}
