Shader "Unlit/WallhackShader"
{
    Properties // the UI of the Shader
    {
        _OutlineSize("OutlineSize", Float) = 0.1
        _OutlineColor ("OutlineColor", Color) = (1,0,0,1)
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            ZTest Greater
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
            };

            struct VertexToFragment
            {
                float4 position : SV_POSITION;
            };

            float4 _OutlineColor;
            float _OutlineSize;

            VertexToFragment VertexShader_ (VertexData vertexData)
            {
                VertexToFragment output;
           
                //float3 pushDirection = normalize(mul(UNITY_MATRIX_M,vertexData.normal)) * _OutlineSize;
                //float4 worldSpacePosition = mul(UNITY_MATRIX_M, vertexData.position);
                //vertexData.position.xyz += pushDirection;

                output.position = UnityObjectToClipPos(vertexData.position);
                return output;
            }

            float4 FragmentShader (VertexToFragment vertexToFragment) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }
    }
}
