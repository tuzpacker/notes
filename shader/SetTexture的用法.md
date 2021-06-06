# shader中setTexture的用法  
  - 与frag shader同级，主要用来处理纹理的一些混合操作
- 使用combine 对不同的源属性操作

``` javascript
Shader "Examples/Self-Illumination" {
    Properties {
        _MainTex ("Base (RGB) Self-Illumination (A)", 2D) = "white" {}
    }
    SubShader {
        Pass {
            // Set up basic white vertex lighting
            //设置白色顶点光照
            Material {
                Diffuse (1,1,1,1)//漫反射颜色设置
                Ambient (1,1,1,1)//环境光反射颜色设置
            }
            Lighting On

            // Use texture alpha to blend up to white (= full illumination)
            // 使用纹理Alpha来混合白色（完全发光）
            SetTexture [_MainTex] {
                constantColor (1,1,1,1)    //自定义颜色
                combine constant lerp(texture) previous
            }
            // Multiply in texture
            // 和纹理相乘
            SetTexture [_MainTex] {
                combine previous * texture
            }
        }
    }
}
```
给一个物体加边框(很挫，不会发光)
定义一个texture 然后在顶点shader上 offset几个像素，将其作为它的color~~~

``` javascript
        pass1:
        SetTexture[_OutlineColor]
		{
		  ConstantColor(0,0,0,0)
		  Combine constant
		}

        pass2:
		v2f vert(appdata v)
		{
		  v2f o;
		  o.pos = UnityObjectToClipPos(v.vertex);

		  float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
		  float2 offset = TransformViewToProjection(norm.xy);

		  o.pos.xy += offset * o.pos.z* _Outline;
		  o.color = _OutlineColor;

		  return o;
```

[参考网址](https://www.cnblogs.com/vsirWaiter/p/5992483.html)
