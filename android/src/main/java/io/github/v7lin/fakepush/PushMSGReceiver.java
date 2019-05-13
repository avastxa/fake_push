package io.github.v7lin.fakepush;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.text.TextUtils;

import com.tencent.android.tpush.XGPushClickedResult;
import com.tencent.android.tpush.XGPushShowedResult;
import com.tencent.android.tpush.XGPushTextMessage;

import java.util.HashMap;
import java.util.Map;

import io.github.v7lin.fakepush.util.JsonUtils;

public abstract class PushMSGReceiver extends BroadcastReceiver {
    private static final String ACTION_MESSAGE = "fake_push.action.MESSAGE";
    private static final String ACTION_NOTIFICATION = "fake_push.action.NOTIFICATION";

    private static final String KEY_EXTRA_MAP = "extraMap";

    @Override
    public final void onReceive(Context context, Intent intent) {
        if (TextUtils.equals(ACTION_MESSAGE, intent.getAction())) {
            onMessage(context, extraMap(intent));
        } else if (TextUtils.equals(ACTION_NOTIFICATION, intent.getAction())) {
            onNotification(context, extraMap(intent));
        }
    }

    private Map<String, Object> extraMap(Intent intent) {
        String json = intent.getStringExtra(KEY_EXTRA_MAP);
        return JsonUtils.toMap(json);
    }

    public abstract void onMessage(Context context, Map<String, Object> map);

    public abstract void onNotification(Context context, Map<String, Object> map);

    public static Map<String, Object> extraMapClick(Intent intent) {
        XGPushClickedResult message = (XGPushClickedResult) intent.getSerializableExtra("tag.tpush.NOTIFIC");
        if (message != null) {
            Map<String, Object> map = new HashMap<>();
            map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE, message.getTitle());
            map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT, message.getContent());
            map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT, message.getCustomContent());
            return map;
        }
        return null;
    }

    public static <PR extends PushMSGReceiver> void registerReceiver(Context context, PR receiver) {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ACTION_NOTIFICATION);
        intentFilter.addAction(ACTION_MESSAGE);
        context.registerReceiver(receiver, intentFilter);
    }

    public static <PR extends PushMSGReceiver> void unregisterReceiver(Context context, PR receiver) {
        context.unregisterReceiver(receiver);
    }

    public static void sendMessage(Context context, XGPushTextMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE, message.getTitle());
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT, message.getContent());
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT, message.getCustomContent());

        Intent receiver = new Intent();
        receiver.setAction(ACTION_MESSAGE);
        receiver.putExtra(KEY_EXTRA_MAP, JsonUtils.toJson(map));
        receiver.setPackage(context.getPackageName());
        context.sendBroadcast(receiver);
    }

    public static void sendNotification(Context context, XGPushShowedResult message) {
        Map<String, Object> map = new HashMap<>();
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE, message.getTitle());
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT, message.getContent());
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT, message.getCustomContent());

        Intent receiver = new Intent();
        receiver.setAction(ACTION_NOTIFICATION);
        receiver.putExtra(KEY_EXTRA_MAP, JsonUtils.toJson(map));
        receiver.setPackage(context.getPackageName());
        context.sendBroadcast(receiver);
    }
}
