/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import type {Node} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Button,
  useColorScheme,
  View,
} from 'react-native';

import { authorize, logout } from 'react-native-app-auth';

import {
  Colors,
  Header,
} from 'react-native/Libraries/NewAppScreen';

const ISSUER = "https://10.0.2.2:8443/realms/pier-stage";

let authState = null;

const makeLogin = async () => {
  // base config
  const config = {
    issuer: ISSUER,
    clientId: 'mobile_app',
    redirectUrl: 'com.mobileapp.auth:/oauth2redirect',
    scopes: ['openid', 'email', 'profile', 'offline_access'],
    usePKCE: true,
  };

  // use the client to make the auth request and receive the authState
  try {
    authState = await authorize(config);
    
    // result includes accessToken, accessTokenExpirationDate and refreshToken
    console.log(authState);
  } catch (error) {
    console.log(error);
  }
};

const makeLogout = async () => {
  if (authState == null)
    return;
    
  const config = {
    issuer: ISSUER,
  };

  try {  
    const result = await logout(config, {
      idToken: authState.idToken,
      postLogoutRedirectUrl: 'com.mobileapp.auth:/oauth2redirect',
    });

    authState = null;
  } catch (error) {
    console.log(error);
  }
};

const App: () => Node = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Button
            onPress={() => makeLogin()}
            title="Login"
            color="#841584"
          />

          <Button
            onPress={() => makeLogout()}
            title="Logout"
            color="#6ACCBC"
          />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
