Shader "Unlit/CircularProgress"
{
	Properties {
	    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	    _MaskTex ("Mask (RGB) Trans (A)", 2D) = "white" {}
	    _Cutoff ("Cutoff", Range(0, 1)) = 0.5
	}

	SubShader {
	    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	    LOD 100

	    ZWrite Off
	    Blend SrcAlpha OneMinusSrcAlpha

	    Pass {
	        CGPROGRAM
	            #pragma vertex vert
	            #pragma fragment frag
	            #pragma target 2.0
	            #pragma multi_compile_fog

	            #include "UnityCG.cginc"

	            struct appdata_t {
	                float4 vertex : POSITION;
	                float2 texcoord : TEXCOORD0;
	            };

	            struct v2f {
	                float4 vertex : SV_POSITION;
	                float2 texcoord : TEXCOORD0;
	                UNITY_FOG_COORDS(1)
	            };

	            sampler2D _MainTex;
	            sampler2D _MaskTex;
	            float _Cutoff;
	            float4 _MainTex_ST;

	            v2f vert (appdata_t v)
	            {
	                v2f o;
	                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
	                UNITY_TRANSFER_FOG(o,o.vertex);
	                return o;
	            }

	            fixed4 frag (v2f i) : SV_Target
	            {
	                fixed4 col = tex2D(_MainTex, i.texcoord);
	                fixed4 mask = tex2D(_MaskTex, i.texcoord);
	                if (_Cutoff == 0)
	                	col.a = 0;
	                else if (mask.r > _Cutoff)
		                col.a = 0;
	                UNITY_APPLY_FOG(i.fogCoord, col);
	                return col;
	            }
	        ENDCG
	    }
	}
}
