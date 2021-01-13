using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class WaterShaderDriver : MonoBehaviour
{
    [SerializeField]
    public Material m_material;

    [SerializeField]
    private MeshRenderer m_renderer;
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        m_material.SetVector("WaterLevelOrigin", transform.position);
        m_material.SetVector("WaterLevelNormal", transform.up);
    }
}
