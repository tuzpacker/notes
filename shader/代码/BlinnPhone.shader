Shader "Custom/BlinnPhone"
{
    Properties
    {
		_Color("Color", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1, 0, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Diffuse("Color", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8,256)) = 10
    }
		SubShader
		{
			Tags { "LightMode" = "ForwardBase" }
			Tags { "RenderType" = "Opaque" }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			sampler2D _MainTex;
			float4  _MainTex_ST;
			fixed4 _Color;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos: SV_POSITION;					
				float3 worldNormal: TEXCOORD0;
				float3 worldPos: TEXCOORD1;
				float2 uv : TEXCOORD2;
			};


			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = v.texcoord.xy*_MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) :SV_Target{
				fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//saturate 过滤大于1 小于0的值
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));


				// blinn-phone与phone差别在于不用计算反射光方向，减少了逐顶点的计算量
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}

			ENDCG
		} 
		}
    FallBack "Diffuse"
}
