Shader "Unlit/SphereInside" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		// Non-lightmapped
		Pass {
			
			Lighting Off
			Cull Front
			SetTexture [_MainTex] { combine texture } 
		}
	}
}
