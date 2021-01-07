﻿Shader "Unlit/FireShader"
{
    Properties // the UI of the Shader
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture", 2D) = "white" {}
        _ScrollSpeed("Scroll Speed", Float) = 1.0
        _Threshold ("Threshold", Range(0,1)) = 0.5
        _Smoothness ("Smoothness", Range(0,0.2)) = 0.1
        _Color ("Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }  // Tag the Shader as Transparent 
        LOD 100
        ZWrite Off
        Blend One One // Equals to additive Blending

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
                float2 uv : TEXCOORD0;
                float4 position : SV_POSITION;
                float3 normal   : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NoiseTex; 
            float _ScrollSpeed;
            float _Threshold;
            float _Smoothness;
            float4 _Color;

            VertexToFragment VertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
                output.position = UnityObjectToClipPos(vertexData.position);
                output.uv = vertexData.uv;
                return output;
            }

            float inverseLerp(float v, float min, float max) {
                return (v - min)/(max-min);
            }

            float remap(float v, float min, float max, float outMin, float outMax) {
                float t = inverseLerp(v, min, max);
                return lerp(outMin, outMax, t);
            }


            float4 FragmentShader (VertexToFragment vertexToFragment) : SV_Target
            {
                float2 uv = vertexToFragment.uv;
                float2 scrolledUv = vertexToFragment.uv;
                scrolledUv.y += _Time.x * _ScrollSpeed * -1;
                // sample the texture
                float4 maskCol = tex2D(_MainTex, uv);
                float4 noiseCol = tex2D(_NoiseTex, scrolledUv);

                float combined = maskCol.x * noiseCol.x;

                float sharpenedResult = inverseLerp(combined, _Threshold - _Smoothness, _Threshold + _Smoothness);
                sharpenedResult = saturate(sharpenedResult); //clamp between 0 and 1
                return sharpenedResult * _Color;
            }
            ENDCG
        }
    }
}
