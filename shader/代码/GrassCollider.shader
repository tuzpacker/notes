Shader "Custom/GrassCollider"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
	SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			Pass {
			Cull Off
			Tags { "LightMode" = "Always" }
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct v2f {
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					float3 normal : TEXCOOL1;
					float3 worldPos : TEXCOORD2;
				};
			
				sampler2D _MainTex;
				float4 _offset;
				uniform float4 _MainTex_ST;

				v2f vert(appdata_base v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex + v.vertex.y*0.8*_offset);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					UNITY_TRANSFER_FOG(o, o.vertex);
	
					o.normal = UnityObjectToWorldNormal(v.normal);
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
	
					return o;
				}

				uniform sampler2D _MainTex2;
				uniform fixed _Cutoff;
				uniform fixed4 _Color;

				float4 frag(v2f i) : COLOR
				{
					fixed4 texcol = tex2D(_MainTex2, i.uv);
					clip(texcol.a*_Color.a - _Cutoff);
	
					SHADOW_CASTER_FRAGMENT(i)
				}
				ENDCG
			} 
		}
}
