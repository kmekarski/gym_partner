/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const {initializeApp, applicationDefault} = require("firebase-admin/app");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {getFirestore} = require("firebase-admin/firestore");
// const logger = require("firebase-functions/logger");

initializeApp({
  credential: applicationDefault(),
});

const db = getFirestore();
const onDocumentWrittenUrl = "users/{userId}";

const getMonthSlashYearString = (date) => {
  const month = ("0" + (date.getMonth() + 1)).slice(-2);
  const year = date.getFullYear().toString().slice(-2);
  return `${month}/${year}`;
};

const calculateWeeklyChartData = (history) => {
  const weeklyChartData = {};

  const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  daysOfWeek.forEach((day) => {
    weeklyChartData[day] = {
      exercises: 0,
      sets: 0,
      time: 0,
    };
  });

  const now = new Date();
  for (let i = 0; i < 6; i++) {
    const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
    const dayOfWeek = daysOfWeek[date.getDay()];

    history.forEach((workout) => {
      const timestamp = workout.timestamp.toDate();
      if (timestamp.toDateString() === date.toDateString()) {
        weeklyChartData[dayOfWeek].exercises += workout.num_of_exercises;
        weeklyChartData[dayOfWeek].sets += workout.num_of_sets;
        weeklyChartData[dayOfWeek].time += workout.time_in_seconds;
      }
    });
  }
  return weeklyChartData;
};

const calculateMonthlyChartData = (history) => {
  const monthlyChartData = {};
  const now = new Date();
  const currentDayOfMonth = now.getDate();
  for (let i = 0; i < currentDayOfMonth; i++) {
    const dayOfMonth = (currentDayOfMonth - i).toString();
    monthlyChartData[dayOfMonth] = {
      exercises: 0,
      sets: 0,
      time: 0,
    };
    const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);

    history.forEach((workout) => {
      const timestamp = workout.timestamp.toDate();
      if (timestamp.toDateString() === date.toDateString()) {
        monthlyChartData[dayOfMonth].exercises += workout.num_of_exercises;
        monthlyChartData[dayOfMonth].sets += workout.num_of_sets;
        monthlyChartData[dayOfMonth].time += workout.time_in_seconds;
      }
    });
  }
  return monthlyChartData;
};

const calculateAllTimeChartData = (history) => {
  const allTimeChartData = {};
  const now = new Date();

  let firstWorkoutDate = history[0].timestamp.toDate();
  history.forEach((workout) => {
    const timestamp = workout.timestamp.toDate();
    if (timestamp < firstWorkoutDate) {
      firstWorkoutDate = timestamp;
    }
  });

  for (let date = firstWorkoutDate;
    date<now; date.setMonth(date.getMonth()+1)) {
    const key = getMonthSlashYearString(date);
    allTimeChartData[key] = {
      exercises: 0,
      sets: 0,
      time: 0,
    };

    history.forEach((workout) => {
      const timestamp = workout.timestamp.toDate();
      if (timestamp.toDateString() === date.toDateString()) {
        allTimeChartData[key].exercises += workout.num_of_exercises;
        allTimeChartData[key].sets += workout.num_of_sets;
        allTimeChartData[key].time += workout.time_in_seconds;
      }
    });
  }
  return allTimeChartData;
};

exports.myfunction = onDocumentUpdated(onDocumentWrittenUrl, async (event) => {
  const history = event.data.after.data()["workouts_history"];
  const prevHistory = event.data.before.data()["workouts_history"];

  if (history.length == prevHistory.length) {
    return null;
  }

  let allTimeExercisesCount = 0;
  let allTimeSetsCount = 0;
  let allTimeWorkoutTime = 0;
  let weeklyExercisesCount = 0;
  let weeklySetsCount = 0;
  let weeklyWorkoutTime = 0;
  let monthlyExercisesCount = 0;
  let monthlySetsCount = 0;
  let monthlyWorkoutTime = 0;

  const now = new Date();
  const oneWeekInSeconds = 7 * 24 * 60 * 60 * 1000;
  const lastWeek = new Date(now.getTime() - oneWeekInSeconds);
  const thisMonth = now.getMonth();
  for (let i = 0; i < history.length; i++) {
    const workout = history[i];
    const timestamp = workout.timestamp.toDate();

    allTimeExercisesCount += workout.num_of_exercises;
    allTimeSetsCount += workout.num_of_sets;
    allTimeWorkoutTime += workout.time_in_seconds;

    if (timestamp > lastWeek) {
      weeklyExercisesCount += workout.num_of_exercises;
      weeklySetsCount += workout.num_of_sets;
      weeklyWorkoutTime += workout.time_in_seconds;
    }

    if (timestamp.getMonth() == thisMonth) {
      monthlyExercisesCount += workout.num_of_exercises;
      monthlySetsCount += workout.num_of_sets;
      monthlyWorkoutTime += workout.time_in_seconds;
    }
  }

  db.collection("users").doc(event.params.userId).set({
    "total_stats_data": {
      "last_week": {
        "exercises": weeklyExercisesCount,
        "sets": weeklySetsCount,
        "time": weeklyWorkoutTime,
      },
      "this_month": {
        "exercises": monthlyExercisesCount,
        "sets": monthlySetsCount,
        "time": monthlyWorkoutTime,
      },
      "all_time": {
        "exercises": allTimeExercisesCount,
        "sets": allTimeSetsCount,
        "time": allTimeWorkoutTime,
      },
    },
  }, {merge: true});

  const weeklyChartData = calculateWeeklyChartData(history);
  const monthlyChartData = calculateMonthlyChartData(history);
  const allTimeChartData = calculateAllTimeChartData(history);

  db.collection("users").doc(event.params.userId).set({
    "chart_data": {
      "last_week": weeklyChartData,
      "this_month": monthlyChartData,
      "all_time": allTimeChartData,
    },
  }, {merge: true});
});
