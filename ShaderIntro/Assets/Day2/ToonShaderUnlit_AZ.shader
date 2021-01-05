﻿Shader "Unlit/ToonShaderUnlit_AZ"
{
    Properties // the UI of the Shader
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("A Color", Color) = (1,1,1,1)
        _Value ("A Value", Float) = 1.0
        _SunDirection ("Sun Direction", Vector) = (0,1,0,0)
        _LightThreshold ("Light Threshold", Float) = 0.0
        _BrightColor ("Bright Color", Color) = (1,1,1,1)
        _DarkColor ("Dark Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex VertexShader_
            #pragma fragment FragmentShader
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct VertexData // structs are groups of values, they cannot hold functions
            {
                float4 position : POSITION;
                float3 normal   : NORMAL;
                float2 uv       : TEXCOORD0;
            };

            struct VertexToFragment
            {
                float2 uv       : TEXCOORD0;
                float3 normal   : NORMAL;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _SunDirection;
            float1 _LightThreshold;

            float3 _BrightColor;
            float3 _DarkColor;

            VertexToFragment VertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
                output.position = UnityObjectToClipPos(vertexData.position);
                output.normal = vertexData.normal;
                output.uv = vertexData.uv;
                return output;
            }

            float4 FragmentShader (VertexToFragment vertexToFragment) : SV_Target
            {
                float3 normal = normalize(vertexToFragment.normal);
                _SunDirection = normalize(_SunDirection);
                float dotProduct = dot(normal, _SunDirection);

                float3 lightColor;
                if(dotProduct > _LightThreshold)
                {
                    lightColor = _BrightColor;
                } 
                else { lightColor = _DarkColor; }


                // sample the texture
                float3 texColor = tex2D(_MainTex, vertexToFragment.uv);
                float3 col = texColor * lightColor;
                return float4(col, 1);
            }
            ENDCG
        }
    }
}