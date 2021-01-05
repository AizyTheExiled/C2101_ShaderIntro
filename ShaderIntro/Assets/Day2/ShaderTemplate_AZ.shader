Shader "Unlit/ShaderTemplate_AZ"
{
    Properties // the UI of the Shader
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("A Color", Color) = (1,0,0,1)
        _Value ("A Value", Vector) = (0,0,0,0)
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
                float2 uv : TEXCOORD0;
                float4 position : SV_POSITION;
                float3 normal   : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            VertexToFragment VertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
                output.position = UnityObjectToClipPos(vertexData.position);
                output.uv = vertexData.uv;
                return output;
            }

            float4 FragmentShader (VertexToFragment vertexToFragment) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, vertexToFragment.uv);
                return col;
            }
            ENDCG
        }
    }
}
