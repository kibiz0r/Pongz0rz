using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class Server : MonoBehaviour
{
    public GameObject PlayerGroup;
    public GameObject Ball;
    public GameObject Paddle;
    public Dictionary<Guid, GameObject> PaddleDictionary = new Dictionary<Guid, GameObject>();

    // Use this for initialization
    void Start()
    {
        NetworkConnectionError error = Network.InitializeServer(32, 25000);
        if (error != NetworkConnectionError.NoError)
        {
            Debug.Log(error);
        }
    }

    // Update is called once per frame
    void Update()
    {
    }

    void OnPlayerConnected(NetworkPlayer player)
    {
        GameObject playerGroup = Network.Instantiate(PlayerGroup, Vector3.zero, Quaternion.identity, 0) as GameObject;
        GameObject ball = Network.Instantiate(Ball, Vector3.zero, Quaternion.identity, 0) as GameObject;
        GameObject paddle = Network.Instantiate(Paddle, Vector3.zero, Quaternion.identity, 0) as GameObject;
        Guid guid = Guid.NewGuid();
        paddle.GetComponent<Paddle>().Guid = guid;
        PaddleDictionary.Add(guid, paddle);
        networkView.RPC("MakeController", player, guid);
    }
}
