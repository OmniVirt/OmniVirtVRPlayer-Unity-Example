Shader "Unlit/HalfSphere"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}
		[Toggle] _clipped ("Clipped", Float) = 0
		_clipUVMinX ("Clip UV Min (X)", Float) = 0
		_clipUVMaxX ("Clip UV Max (X)", Float) = 0
		[Toggle] _flipX ("Flip X", Float) = 0
		_offsetX ("Offset (X)", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _clipped;
			float _clipUVMinX;
			float _clipUVMaxX;
			float _flipX;
			float _offsetX;
			
			v2f vert (appdata v)
			{
				v2f o;
//				o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// Flip Texture Horizontally
				if (_clipped > 0) {
					if (i.uv.x < _clipUVMinX || i.uv.x > _clipUVMaxX) {
						return 0;
					}
				}
				if (_flipX > 0)
					i.uv.x = 1 - i.uv.x;
				i.uv.x = i.uv.x + _offsetX;
				if (i.uv.x > 1)
					i.uv.x -= 1;
				if (i.uv.x < 0)
					i.uv.x += 1;
				// Sample the Texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// Clip
				return col;
			}
			ENDCG
		}
	}
}
