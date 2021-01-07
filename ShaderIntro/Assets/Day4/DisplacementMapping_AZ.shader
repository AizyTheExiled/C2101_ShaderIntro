Shader "Unlit/DisplacementMapping_AZ"
{
    Properties // the UI of the Shader
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
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

            VertexToFragment VertexShader_ (VertexData vertexData) // Object Space
            {
                VertexToFragment output;
                float3 worldNormal = mul(UNITY_MATRIX_M, vertexData.normal);
                float4 worldPosition = mul(UNITY_MATRIX_M, vertexData.position);

                float isFacingUp = dot(vertexData.normal, float3(0,1,0));
                isFacingUp = saturate(isFacingUp);

                float3 displacementDirection = vertexData.normal;
                float4 displacementFactor = tex2Dlod(_MainTex, float4(vertexData.uv,0,0));
                displacementDirection *= displacementFactor * isFacingUp;

                float4 displacedPosition = worldPosition;
                displacedPosition.xyz += displacementDirection;

                output.position = mul(UNITY_MATRIX_VP, displacedPosition);
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
