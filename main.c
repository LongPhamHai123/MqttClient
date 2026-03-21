#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MQTTClient.h"

#include <cjson/cJSON.h>

#define ADDRESS     "tcps://broker.hivemq.com:8883"
#define CLIENTID    "ExampleClient"
#define TOPIC       "MQTT Examples"
#define PAYLOAD     "Hello World!"
#define QOS         0
#define TIMEOUT     10000L
 
volatile MQTTClient_deliveryToken deliveredtoken;
 
void delivered(void *context, MQTTClient_deliveryToken dt)
{
    printf("Message with token value %d delivery confirmed\n", dt);
    deliveredtoken = dt;
}
 
int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)
{
    printf("Message arrived\n");
    printf("     topic: %s\n", topicName);
    printf("   message: %.*s\n", message->payloadlen, (char*)message->payload);
    char *json_str = malloc(message->payloadlen + 1);
    memcpy(json_str, message->payload, message->payloadlen);
    json_str[message->payloadlen] = '\0';
    cJSON *root = cJSON_Parse(json_str);
    if (root != NULL) {
        // printf("JSON parse error\n");
        cJSON *msg = cJSON_GetObjectItem(root, "msg");
        if (cJSON_IsString(msg) && msg->valuestring != NULL) {
            printf("msg: %s\n", msg->valuestring);
        }
        cJSON_Delete(root);
    }
    free(json_str);
    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}
 
void connlost(void *context, char *cause)
{
    printf("\nConnection lost\n");
    printf("     cause: %s\n", cause);
}
 
int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    int rc;
 
    if ((rc = MQTTClient_create(&client, ADDRESS, CLIENTID,
        MQTTCLIENT_PERSISTENCE_NONE, NULL)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to create client, return code %d\n", rc);
        rc = EXIT_FAILURE;
        goto exit;
    }
 
    if ((rc = MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to set callbacks, return code %d\n", rc);
        rc = EXIT_FAILURE;
        goto destroy_exit;
    }
 
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 5;
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        rc = EXIT_FAILURE;
        goto destroy_exit;
    }
 
    printf("Subscribing to topic %s\nfor client %s using QoS%d\n\n"
           "Press Q<Enter> to quit\n\n", TOPIC, CLIENTID, QOS);
    if ((rc = MQTTClient_subscribe(client, TOPIC, QOS)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to subscribe, return code %d\n", rc);
        rc = EXIT_FAILURE;
    }
    else
    {
        int ch;
        do
        {
                ch = getchar();
        } while (ch!='Q' && ch != 'q');
 
        if ((rc = MQTTClient_unsubscribe(client, TOPIC)) != MQTTCLIENT_SUCCESS)
        {
                printf("Failed to unsubscribe, return code %d\n", rc);
                rc = EXIT_FAILURE;
        }
    }
 
    if ((rc = MQTTClient_disconnect(client, 10000)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to disconnect, return code %d\n", rc);
        rc = EXIT_FAILURE;
    }
destroy_exit:
    MQTTClient_destroy(&client);
exit:
    return rc;

    // char* json_str = (char*) malloc(50*sizeof(char));
    // strcpy(json_str, "{ \"msg\": \"hehe\"}");
    // cJSON *root = cJSON_Parse(json_str);
    // if (root != NULL) {
    //     // printf("JSON parse error\n");
    //     cJSON *msg = cJSON_GetObjectItem(root, "msg");
    //     if (cJSON_IsString(msg) && msg->valuestring != NULL) {
    //         printf("msg: %s\n", msg->valuestring);
    //     }

    //     cJSON_Delete(root);
    // }
    // free(json_str);
}