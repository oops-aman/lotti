import React, {memo} from 'react';
import {StyleSheet, View} from 'react-native';
import Colors from 'src/constants/colors';
import {AudioRecorder} from 'src/components/AudioRecorder';

function Home() {
  return (
    <View style={styles.container}>
      <AudioRecorder />
    </View>
  );
}

export default memo(Home);

const styles = StyleSheet.create({
  container: {
    paddingTop: 50,
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: Colors.darkCharcoal,
  },
});
