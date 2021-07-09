package com.mycompany.myapp;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Debug;
import android.util.Log;

import org.qtproject.qt5.android.bindings.QtActivity;

public class MyAppActivity extends QtActivity
{
  private static MyAppActivity s_activity = null;

  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    s_activity = this;
  }

  @Override
  protected void onDestroy()
  {
    super.onDestroy();
    s_activity = null;
  }

  public static void sendMailWithSubject(String subject, String body)
  {
    Log.d("MyAppActivity", "in custom java for sendMail");
    Log.d("MyAppActivity", "s_activity=" + s_activity);
    if (null == s_activity){
      return;
    }

    try
    {
      Uri uri = Uri.parse("mailto:noreply@replaceme_TODO.com")
                .buildUpon()
                .appendQueryParameter("subject", subject)
                .appendQueryParameter("body", body)
                .build();
      Intent intent = new Intent(Intent.ACTION_SEND, uri);
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // | Intent.FLAG_ACTIVITY_MULTIPLE_TASK);

      intent.setType("message/rfc822"); // supposedly unnecessary, but I needed it.

      // https://stackoverflow.com/questions/8701634/send-email-intent
      // These SHOULD BE REDUNDANT (given the above), but may be useful on some Android versions.
      intent.putExtra(Intent.EXTRA_EMAIL, new String[] {"noreply@replaceme_TODO.com"});
      intent.putExtra(Intent.EXTRA_SUBJECT, subject);
      intent.putExtra(Intent.EXTRA_TEXT, body);

      Intent mailer = Intent.createChooser(intent, "Send mail...");
      mailer.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      if(mailer == null)
      {
        Log.e("MyAppActivity", "Couldn't get Mail Intent");
        return;
      }
      Log.d("MyAppActivity", "custom java code: got mailer");

      s_activity.getApplicationContext().startActivity(mailer);
    }
    catch (android.content.ActivityNotFoundException ex)
    {
      Log.e("MyAppActivity", "caught android.content.ActivityNotFoundException");
      ex.printStackTrace();
    }

    Log.d("MyAppActivity", "java-code: sendMail(): END");
  }

  public static boolean isAndroidDebuggerConnected()
  {
    Log.d("MyAppActivity", "call to isAndroidDebuggerConnected");
    return Debug.isDebuggerConnected();
  }

  // TODO: add isRunningGoogleFirebaseAutomatedTests https://stackoverflow.com/questions/43598250/how-to-detect-running-in-firebase-test-lab
  //   (we want to make all alerts auto-expire/auto-hide in firebase, so their
  //    "blind" click-everywhere test bot isn't stuck with a modal popup)
}
