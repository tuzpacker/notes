// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Chapter5-SimpleShader"
{
    Properties
    {
		_Color("Color Tint",Color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members pos)
			//#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			// 引入color
			fixed4 _Color;

			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f {
				float4 pos:SV_POSITION;
				fixed3 color : COLOR0;
			};
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (a2v v)
            {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 c = i.color;
				c *= _Color.rgb;
			   return fixed4(c,1.0);
            }
            ENDCG
        }
    }
}
