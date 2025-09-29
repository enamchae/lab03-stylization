void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten) {
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
    #else
        float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ChooseColor_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseColor3_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float Threshold_Hi, float Threshold_Lo, float Smoothness, out float3 OUT)
{
    //if (Diffuse > Threshold_Hi)
    //{
    //    OUT = Highlight;
    //}
    //else if (Diffuse < Threshold_Lo)
    //{
    //    OUT = Shadow;
    //}
    //else
    //{
    //    OUT = Midtone;
    //}
    
    float3 lo = lerp(Shadow, Midtone, smoothstep(Threshold_Lo - Smoothness, Threshold_Lo + Smoothness, Diffuse));
    OUT = lerp(lo, Highlight, smoothstep(Threshold_Hi - Smoothness, Threshold_Hi + Smoothness, Diffuse));
}