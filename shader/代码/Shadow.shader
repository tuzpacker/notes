Shader "Custom/Shadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		// 不透明物体渲染pass
        Pass
        {
			Name "FORWARD"

			Tags {
				"LightMode"="ForwardBase" "RenderType"="Opaque"
			}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog  这个是默认的各种效果，包括漫反射 实时阴影等

            #include "UnityCG.cginc"

#include "AutoLight.cginc"
			#include "Lighting.cginc"
			
			#pragma multi_compile_fwdbase_fullshadows

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
				float2 texcoord0 : TEXCOORD0;
            };

            struct v2f
            {
				float4 pos : SV_POSITION;
				float3 nDirWS:TEXCOORD0;
				float3 posWS:TEXCOORD2;
				LIGHTING_COORDS(5, 6)
			};

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				o.posWS = mul(unity_ObjectToWorld, v.vertex);
				o.nDirWS = UnityObjectToWorldNormal(v.normal);
				o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }

			float4 frag (v2f i) : COLOR
            {
				float4 finalRGB = 1;

				float3 nDirWS = normalize(i.nDirWS);
				float3 lDirWS = normalize(_WorldSpaceLightPos0.xyz);

				float atten = LIGHT_ATTENUATION(i);

				float NdotL = dot(nDirWS, lDirWS)*atten;
				float halfLambert = NdotL * 0.5 + 0.5;

				finalRGB.rgb = 1 * halfLambert;

				return float4(finalRGB.rgb, 1);
            }
            ENDCG
        }
		Pass{
			Name "ShadowCaster"
			Tags{"LightMode" = "ShadowCaster"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			struct v2f {
				V2F_SHADOW_CASTER;
			};
			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}
			float4 frag(v2f i):SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
    }
}
