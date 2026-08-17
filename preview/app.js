// Achieve — App State & Controller
const SAMPLE_GOALS = [
    {
      id: 'goal-1',
      title: 'Master Conversational Spanish',
      why: 'To connect deeply with locals, understand cultural nuances, and unlock new professional horizons.',
      category: 'Learning',
      emoji: '🇪🇸',
      status: 'on-track',
      statusText: '● On Track',
      targetDate: 'Feb 2027',
      routine: {
        frequency: '4x / week',
        days: 'Mon, Tue, Thu, Sat',
        time: '08:00 AM (30 min)'
      },
      milestones: [
        {
          id: 'm1-1',
          title: 'Foundational 500 Words & Core Grammar',
          isCompleted: true,
          actions: [
            { id: 'act-1', title: 'Review 50 flashcards (Anki)', minutes: 20, time: '08:00 AM', completed: true },
            { id: 'act-2', title: 'Complete Subjunctive Verb workbook', minutes: 30, time: '08:30 AM', completed: true }
          ]
        },
        {
          id: 'm1-2',
          title: 'Conversational Fluency & Listening Sprint',
          isCompleted: false,
          actions: [
            { id: 'act-3', title: '30m iTalki tutor conversation', minutes: 30, time: '08:00 AM', completed: true },
            { id: 'act-4', title: 'Listen to Radio Ambulante podcast episode', minutes: 25, time: '06:00 PM', completed: false },
            { id: 'act-5', title: 'Shadowing speech technique practice', minutes: 15, time: '09:00 PM', completed: false }
          ]
        },
        {
          id: 'm1-3',
          title: 'Native Immersion & Novel Reading',
          isCompleted: false,
          actions: [
            { id: 'act-6', title: 'Read chapter 1 & underline unknown idioms', minutes: 30, time: '08:00 PM', completed: false }
          ]
        }
      ]
    },
    {
      id: 'goal-2',
      title: 'Run First Sub-4-Hour Marathon',
      why: 'Build peak cardiovascular fitness, mental resilience, and lifelong physical discipline.',
      category: 'Health',
      emoji: '🏃‍♂️',
      status: 'ahead',
      statusText: '● Ahead',
      targetDate: 'Nov 2026',
      routine: {
        frequency: '4x / week',
        days: 'Mon, Wed, Fri, Sun',
        time: '06:30 AM (60 min)'
      },
      milestones: [
        {
          id: 'm2-1',
          title: 'Base Aerobic Capacity (15km Long Runs)',
          isCompleted: true,
          actions: [
            { id: 'act-7', title: '15km Sunday endurance run', minutes: 85, time: '06:30 AM', completed: true },
            { id: 'act-8', title: 'Interval 800m repeats (x6)', minutes: 45, time: '07:00 AM', completed: true }
          ]
        },
        {
          id: 'm2-2',
          title: 'Lactate Threshold & Sustained Tempo (25km)',
          isCompleted: false,
          actions: [
            { id: 'act-9', title: '12km Tempo at 5:35 min/km', minutes: 65, time: '06:30 AM', completed: false }
          ]
        }
      ]
    },
    {
      id: 'goal-3',
      title: 'Launch SaaS Product to $5K MRR',
      why: 'Achieve location independence, craft beloved consumer software, and achieve financial autonomy.',
      category: 'Career',
      emoji: '🚀',
      status: 'needs-attention',
      statusText: '● Needs Attention',
      targetDate: 'Jan 2027',
      routine: {
        frequency: '3x / week',
        days: 'Tue, Thu, Sat',
        time: '07:00 PM (90 min)'
      },
      milestones: [
        {
          id: 'm3-1',
          title: 'User Problem Validation & Prototype',
          isCompleted: true,
          actions: [
            { id: 'act-10', title: '5 customer discovery calls', minutes: 60, time: '05:00 PM', completed: true }
          ]
        },
        {
          id: 'm3-2',
          title: 'Core MVP Architecture & Payment Gateway',
          isCompleted: false,
          actions: [
            { id: 'act-11', title: 'Build Stripe webhook handler', minutes: 60, time: '07:00 PM', completed: false }
          ]
        }
      ]
    }
];

let state = {
  currentUser: { name: 'Alex Rivera', email: 'alex@achieve.app', isDemo: true },
  activeScreen: 'screenToday',
  selectedGoalId: 'goal-1',
  activeMilestoneForStep: null,
  streak: 14,
  goals: JSON.parse(JSON.stringify(SAMPLE_GOALS)),
  reflection: {
    whatWentWell: 'Completed all marathon tempo runs on schedule and maintained morning Spanish practice without skipping.',
    whatWasDifficult: 'Midweek fatigue made late evening SaaS coding sessions harder to focus on.',
    nextWeekFocus: 'Shift SaaS deep work to early Saturday morning and complete Stripe checkout flow.'
  }
};

// Generate 28-day consistency history
function generateHeatmapData(goal) {
  const days = [];
  const isDemoGoal = goal && (goal.id === 'goal-1' || goal.id === 'goal-2' || goal.id === 'goal-3');
  
  for (let i = 27; i >= 0; i--) {
    let level = 0;
    if (isDemoGoal) {
      if (goal.id === 'goal-1') {
        // Spanish cadence (Mon, Tue, Thu, Sat)
        level = (i % 7 === 1 || i % 7 === 2 || i % 7 === 4 || i % 7 === 6) ? (i % 2 === 0 ? 2 : 1) : 0;
      } else if (goal.id === 'goal-2') {
        // Marathon cadence (Mon, Wed, Fri, Sun)
        level = (i % 7 === 1 || i % 7 === 3 || i % 7 === 5 || i % 7 === 0) ? (i % 3 === 0 ? 3 : 2) : 0;
      } else {
        level = (i % 7 === 2 || i % 7 === 4) ? 1 : 0;
      }
    } else {
      // New goals start with a clean 0 calendar, with today marked if actions completed
      if (i === 0 && goal) {
        let hasCompleted = false;
        goal.milestones.forEach(m => m.actions.forEach(a => { if (a.completed) hasCompleted = true; }));
        level = hasCompleted ? 2 : 0;
      } else {
        level = 0;
      }
    }
    days.push(level);
  }
  return days;
}

// Compute metrics
function getTodayActions() {
  const actions = [];
  state.goals.forEach(goal => {
    goal.milestones.forEach(milestone => {
      milestone.actions.forEach(action => {
        actions.push({
          ...action,
          goalId: goal.id,
          goalTitle: goal.title,
          goalEmoji: goal.emoji,
          milestoneId: milestone.id
        });
      });
    });
  });
  return actions;
}

function getGoalProgress(goal) {
  let total = 0;
  let completed = 0;
  goal.milestones.forEach(m => {
    m.actions.forEach(a => {
      total++;
      if (a.completed) completed++;
    });
  });
  return total === 0 ? 0 : Math.round((completed / total) * 100);
}

// Render Dashboard
function renderDashboard() {
  const allActions = getTodayActions();
  const completedToday = allActions.filter(a => a.completed).length;
  const totalToday = allActions.length;
  const pct = totalToday === 0 ? 0 : Math.round((completedToday / totalToday) * 100);

  // Update ring
  const circleCircumference = 238.76;
  const offset = circleCircumference - (pct / 100) * circleCircumference;
  const ringFg = document.getElementById('dailyRingFg');
  if (ringFg) ringFg.style.strokeDashoffset = offset;
  
  document.getElementById('dailyPercent').textContent = `${pct}%`;
  document.getElementById('dailyFraction').textContent = `${completedToday}/${totalToday} Done`;
  document.getElementById('todayCompletedFraction').textContent = `${completedToday}/${totalToday} completed`;
  document.getElementById('activeGoalsCount').textContent = `${state.goals.length} in progress`;
  document.getElementById('streakCount').textContent = `${state.streak} Day Streak`;

  // Render Active Goals Carousel
  const carousel = document.getElementById('goalsCarousel');
  if (state.goals.length === 0) {
    carousel.innerHTML = '<div style="padding: 20px; color: var(--text-muted); font-size: 13px;">No active goals yet. Tap "+ Goal" to create one.</div>';
  } else {
    carousel.innerHTML = state.goals.map(goal => {
      const progress = getGoalProgress(goal);
      let totalActions = 0;
      let completedActions = 0;
      goal.milestones.forEach(m => {
        m.actions.forEach(a => {
          totalActions++;
          if (a.completed) completedActions++;
        });
      });

      return `
        <div class="goal-card-carousel" data-goal-id="${goal.id}">
          <div class="goal-card-top">
            <div class="goal-emoji-icon">${goal.emoji}</div>
            <div class="status-badge ${goal.status}">${goal.statusText}</div>
          </div>
          <div class="goal-card-title">${goal.title}</div>
          <div>
            <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-bottom: 5px;">
              <span>${completedActions}/${totalActions} actions</span>
              <span style="font-weight: 600; color: var(--primary);">${progress}%</span>
            </div>
            <div class="progress-track">
              <div class="progress-fill" style="width: ${progress}%;"></div>
            </div>
          </div>
        </div>
      `;
    }).join('');
  }

  // Render Today Actions Grouped by Goal (Issue 4 Fix)
  const actionsList = document.getElementById('todayActionsList');
  if (state.goals.length === 0 || allActions.length === 0) {
    actionsList.innerHTML = `
      <div class="apple-card" style="text-align: center; padding: 24px;">
        <div style="font-size: 32px; margin-bottom: 8px;">🎯</div>
        <div style="font-weight: 600; margin-bottom: 4px;">No action plans today</div>
        <div style="font-size: 12px; color: var(--text-muted);">Create a goal to start building your daily execution rhythm.</div>
      </div>
    `;
  } else {
    // Group by goal
    actionsList.innerHTML = state.goals.map(goal => {
      let goalActions = [];
      goal.milestones.forEach(m => {
        m.actions.forEach(a => {
          goalActions.push({ ...a, milestoneId: m.id, goalId: goal.id });
        });
      });

      if (goalActions.length === 0) return '';
      const goalDone = goalActions.filter(a => a.completed).length;
      const goalPct = Math.round((goalDone / goalActions.length) * 100);

      return `
        <div class="apple-card" style="padding: 14px; margin-bottom: 12px;">
          <div class="goal-group-header" data-goal-toggle="${goal.id}" style="cursor: pointer;">
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
              <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-size: 18px;">${goal.emoji}</span>
                <span style="font-weight: 700; font-size: 14px;">${goal.title}</span>
              </div>
              <span style="font-size: 11px; font-weight: 600; color: ${goalDone === goalActions.length ? 'var(--status-on-track)' : 'var(--primary)'}; background: rgba(0,102,204,0.08); padding: 3px 8px; border-radius: 20px;">
                ${goalDone}/${goalActions.length} today (${goalPct}%)
              </span>
            </div>
            <div class="progress-track" style="margin-bottom: 8px; height: 4px;">
              <div class="progress-fill" style="width: ${goalPct}%; background: ${goalDone === goalActions.length ? 'var(--status-on-track)' : 'var(--primary)'}"></div>
            </div>
          </div>
          <div class="goal-group-actions" id="group-actions-${goal.id}">
            ${goalActions.map(action => `
              <div class="action-card ${action.completed ? 'completed' : ''}" style="margin-top: 6px; padding: 10px 12px;" data-goal-id="${goal.id}" data-milestone-id="${action.milestoneId}" data-action-id="${action.id}">
                <div class="checkbox-circle" style="width: 20px; height: 20px;"></div>
                <div class="action-details">
                  <div class="action-title" style="font-size: 13px;">${action.title}</div>
                  <div class="action-meta">
                    <span>${action.minutes || 30}m</span>
                  </div>
                </div>
                <div class="time-pill" style="font-size: 10px;">${action.time || goal.routine.time}</div>
              </div>
            `).join('')}
          </div>
        </div>
      `;
    }).join('');
  }

  // Add click events to carousel items
  carousel.querySelectorAll('.goal-card-carousel').forEach(card => {
    card.addEventListener('click', () => {
      const goalId = card.getAttribute('data-goal-id');
      openGoalDetail(goalId);
    });
  });

  // Add click events to action items
  actionsList.querySelectorAll('.action-card').forEach(card => {
    card.addEventListener('click', () => {
      const goalId = card.getAttribute('data-goal-id');
      const mId = card.getAttribute('data-milestone-id');
      const aId = card.getAttribute('data-action-id');
      toggleAction(goalId, mId, aId);
    });
  });
}

// Render Goal Detail
function renderGoalDetail(goalId) {
  const goal = state.goals.find(g => g.id === goalId);
  if (!goal) return;

  state.selectedGoalId = goalId;
  const progress = getGoalProgress(goal);

  document.getElementById('detailCategory').textContent = goal.category.toUpperCase();
  document.getElementById('detailEmoji').textContent = goal.emoji;
  document.getElementById('detailTitle').textContent = goal.title;
  document.getElementById('detailWhy').textContent = `"${goal.why}"`;
  document.getElementById('detailTargetDate').textContent = `Target: ${goal.targetDate}`;
  document.getElementById('detailProgressPercent').textContent = `${progress}% Done`;
  document.getElementById('detailProgressFill').style.width = `${progress}%`;
  
  const statusBadge = document.getElementById('detailStatusBadge');
  statusBadge.className = `status-badge ${goal.status}`;
  statusBadge.textContent = goal.statusText;

  document.getElementById('detailFrequency').textContent = goal.routine.frequency;
  document.getElementById('detailRoutineDays').textContent = goal.routine.days;
  document.getElementById('detailRoutineTime').textContent = goal.routine.time;

  // Heatmap strictly for this goal (Issue 2 Fix)
  const heatmapData = generateHeatmapData(goal);
  const heatmapGrid = document.getElementById('heatmapGrid');
  heatmapGrid.innerHTML = heatmapData.map(val => `<div class="heatmap-cell c${val}">${val > 0 ? val : ''}</div>`).join('');

  // Milestones
  const milestonesContainer = document.getElementById('milestonesContainer');
  const achievedCount = goal.milestones.filter(m => m.isCompleted).length;
  document.getElementById('detailMilestonesAchieved').textContent = `${achievedCount}/${goal.milestones.length} achieved`;

  milestonesContainer.innerHTML = goal.milestones.map((m, idx) => {
    let mTotal = m.actions.length;
    let mDone = m.actions.filter(a => a.completed).length;
    let mPct = mTotal === 0 ? (m.isCompleted ? 100 : 0) : Math.round((mDone / mTotal) * 100);

    return `
      <div class="milestone-card">
        <div class="milestone-header">
          <div class="milestone-num ${m.isCompleted ? 'achieved' : ''}">
            ${m.isCompleted ? '✓' : idx + 1}
          </div>
          <div style="flex: 1;">
            <div class="milestone-title">${m.title}</div>
          </div>
          <span style="font-size: 13px; font-weight: 600; color: ${m.isCompleted ? 'var(--status-on-track)' : 'var(--primary)'}">${mPct}%</span>
        </div>
        <div class="progress-track" style="margin-bottom: 10px;">
          <div class="progress-fill" style="width: ${mPct}%; background: ${m.isCompleted ? 'var(--status-on-track)' : 'var(--primary)'}"></div>
        </div>
        <div class="milestone-steps">
          ${m.actions.map(act => `
            <div class="milestone-step-item ${act.completed ? 'completed' : ''}" data-goal-id="${goal.id}" data-milestone-id="${m.id}" data-action-id="${act.id}">
              <div class="checkbox-circle" style="width: 18px; height: 18px;"></div>
              <span class="milestone-step-name">${act.title}</span>
              <span style="font-size: 11px; color: var(--text-muted);">${act.minutes}m</span>
            </div>
          `).join('')}
        </div>
        <div style="margin-top: 10px;">
          <button class="pill-btn secondary btn-add-step-inline" data-milestone-id="${m.id}" style="font-size: 12px; padding: 4px 10px;">+ Step</button>
        </div>
      </div>
    `;
  }).join('');

  // Add click listener for milestone steps
  milestonesContainer.querySelectorAll('.milestone-step-item').forEach(item => {
    item.addEventListener('click', () => {
      const gId = item.getAttribute('data-goal-id');
      const mId = item.getAttribute('data-milestone-id');
      const aId = item.getAttribute('data-action-id');
      toggleAction(gId, mId, aId);
      renderGoalDetail(goalId);
    });
  });

  // Add click listener for "+ Step" buttons
  milestonesContainer.querySelectorAll('.btn-add-step-inline').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const mId = btn.getAttribute('data-milestone-id');
      openAddStepModal(mId);
    });
  });
}

// Render Reflection Screen
function renderReflection() {
  const txtWell = document.getElementById('txtWhatWentWell');
  const txtDiff = document.getElementById('txtWhatWasDifficult');
  const txtFocus = document.getElementById('txtNextWeekFocus');

  txtWell.value = state.reflection.whatWentWell;
  txtDiff.value = state.reflection.whatWasDifficult;
  txtFocus.value = state.reflection.nextWeekFocus;

  // Category distribution
  const catMap = {};
  state.goals.forEach(g => {
    catMap[g.category] = (catMap[g.category] || 0);
    g.milestones.forEach(m => {
      m.actions.forEach(a => {
        if (a.completed) catMap[g.category]++;
      });
    });
  });

  const totalCompleted = Object.values(catMap).reduce((a, b) => a + b, 0);
  const balanceBars = document.getElementById('balanceBars');

  balanceBars.innerHTML = Object.entries(catMap).map(([cat, count]) => {
    const pct = totalCompleted === 0 ? 0 : Math.round((count / totalCompleted) * 100);
    return `
      <div class="balance-row">
        <div class="balance-labels">
          <span>${cat}</span>
          <span style="color: var(--text-muted); font-size: 12px;">${pct}% (${count} acts)</span>
        </div>
        <div class="progress-track">
          <div class="progress-fill" style="width: ${pct}%;"></div>
        </div>
      </div>
    `;
  }).join('');
}

// Action Toggling
function toggleAction(goalId, milestoneId, actionId) {
  const goal = state.goals.find(g => g.id === goalId);
  if (!goal) return;
  const milestone = goal.milestones.find(m => m.id === milestoneId);
  if (!milestone) return;
  const action = milestone.actions.find(a => a.id === actionId);
  if (!action) return;

  action.completed = !action.completed;

  // Check if milestone completed
  const allDone = milestone.actions.length > 0 && milestone.actions.every(a => a.completed);
  milestone.isCompleted = allDone;

  renderDashboard();
  if (state.activeScreen === 'screenGoalDetail') {
    renderGoalDetail(goalId);
  }
}

// Navigation & Screen Switcher
function switchScreen(screenId) {
  document.querySelectorAll('.app-screen').forEach(s => s.classList.remove('active-screen'));
  const target = document.getElementById(screenId);
  if (target) target.classList.add('active-screen');
  state.activeScreen = screenId;

  // Update tabs
  document.querySelectorAll('.nav-tab').forEach(t => {
    t.classList.toggle('active', t.getAttribute('data-target') === screenId);
  });
}

function openGoalDetail(goalId) {
  renderGoalDetail(goalId);
  switchScreen('screenGoalDetail');
}

// Sheet Modals
function openCreateGoalSheet() {
  document.getElementById('sheetOverlay').classList.add('active');
  document.getElementById('createGoalSheet').classList.add('active');
}

function openProfileSheet() {
  document.getElementById('sheetOverlay').classList.add('active');
  document.getElementById('profileSheet').classList.add('active');
}

function closeSheets() {
  document.getElementById('sheetOverlay').classList.remove('active');
  document.getElementById('createGoalSheet').classList.remove('active');
  document.getElementById('addStepSheet').classList.remove('active');
  const prof = document.getElementById('profileSheet');
  if (prof) prof.classList.remove('active');
}

function openAddStepModal(milestoneId) {
  state.activeMilestoneForStep = milestoneId;
  document.getElementById('sheetOverlay').classList.add('active');
  document.getElementById('addStepSheet').classList.add('active');
}

// Event Listeners Initializer
document.addEventListener('DOMContentLoaded', () => {
  // Navigation tabs
  document.querySelectorAll('.nav-tab').forEach(tab => {
    tab.addEventListener('click', () => {
      const targetScreen = tab.getAttribute('data-target');
      switchScreen(targetScreen);
      if (targetScreen === 'screenReflection') renderReflection();
      if (targetScreen === 'screenToday') renderDashboard();
    });
  });

  // Back button
  document.getElementById('btnBackToDashboard').addEventListener('click', () => {
    switchScreen('screenToday');
    renderDashboard();
  });

  // Open Create Goal & Profile
  document.getElementById('btnOpenCreateGoal').addEventListener('click', openCreateGoalSheet);
  const btnOpenProfile = document.getElementById('btnOpenProfile');
  if (btnOpenProfile) btnOpenProfile.addEventListener('click', openProfileSheet);

  // Auth Screen logic & Logout
  let authMode = 'login';
  const tabAuthLogin = document.getElementById('tabAuthLogin');
  const tabAuthRegister = document.getElementById('tabAuthRegister');
  const groupAuthName = document.getElementById('groupAuthName');
  const btnSubmitAuth = document.getElementById('btnSubmitAuth');

  if (tabAuthLogin && tabAuthRegister) {
    tabAuthLogin.addEventListener('click', () => {
      authMode = 'login';
      tabAuthLogin.className = 'pill-btn primary';
      tabAuthLogin.style.border = 'none';
      tabAuthRegister.className = 'pill-btn secondary';
      tabAuthRegister.style.border = 'none';
      if (groupAuthName) groupAuthName.style.display = 'none';
      if (btnSubmitAuth) btnSubmitAuth.textContent = 'Sign In';
    });

    tabAuthRegister.addEventListener('click', () => {
      authMode = 'register';
      tabAuthRegister.className = 'pill-btn primary';
      tabAuthRegister.style.border = 'none';
      tabAuthLogin.className = 'pill-btn secondary';
      tabAuthLogin.style.border = 'none';
      if (groupAuthName) groupAuthName.style.display = 'block';
      if (btnSubmitAuth) btnSubmitAuth.textContent = 'Create Account';
    });
  }

  function loginUser(name, email, isDemo) {
    state.currentUser = { name, email, isDemo };
    if (isDemo) {
      state.goals = JSON.parse(JSON.stringify(SAMPLE_GOALS));
      state.streak = 14;
    } else {
      state.goals = [];
      state.streak = 0;
    }
    const nav = document.querySelector('.app-bottom-nav');
    if (nav) nav.style.display = 'flex';
    switchScreen('screenToday');
    renderDashboard();
  }

  function logoutUser() {
    state.currentUser = null;
    closeSheets();
    const nav = document.querySelector('.app-bottom-nav');
    if (nav) nav.style.display = 'none';
    switchScreen('screenAuth');
  }

  if (btnSubmitAuth) {
    btnSubmitAuth.addEventListener('click', () => {
      const email = document.getElementById('inputAuthEmail').value.trim() || 'user@achieve.app';
      const name = document.getElementById('inputAuthName')?.value.trim() || email.split('@')[0];
      const isDemo = email.toLowerCase().includes('alex') || email.toLowerCase().includes('demo');
      loginUser(name, email, isDemo);
    });
  }

  const btnAuthQuickDemo = document.getElementById('btnAuthQuickDemo');
  if (btnAuthQuickDemo) {
    btnAuthQuickDemo.addEventListener('click', () => {
      loginUser('Alex Rivera', 'alex@achieve.app', true);
    });
  }

  const btnAuthQuickGuest = document.getElementById('btnAuthQuickGuest');
  if (btnAuthQuickGuest) {
    btnAuthQuickGuest.addEventListener('click', () => {
      loginUser('Guest User', 'guest@achieve.app', false);
    });
  }

  const btnLogoutUser = document.getElementById('btnLogoutUser');
  if (btnLogoutUser) {
    btnLogoutUser.addEventListener('click', () => {
      logoutUser();
    });
  }
  document.getElementById('sheetOverlay').addEventListener('click', closeSheets);

  // Category choice chips in modal
  document.querySelectorAll('#categoryChips .chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('#categoryChips .chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
    });
  });

  // Timeframe choice chips
  document.querySelectorAll('#timeframeChips .chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('#timeframeChips .chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
    });
  });

  // Preferred time chips (Issue 3 Fix)
  document.querySelectorAll('#preferredTimeChips .chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('#preferredTimeChips .chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
    });
  });

  // Session duration chips (Issue 3 Fix)
  document.querySelectorAll('#durationChips .chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('#durationChips .chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
    });
  });

  // Submit New Goal
  document.getElementById('btnSubmitNewGoal').addEventListener('click', () => {
    const title = document.getElementById('inputGoalTitle').value.trim();
    const why = document.getElementById('inputWhy').value.trim();
    if (!title) return;

    const activeCat = document.querySelector('#categoryChips .chip.active');
    const category = activeCat ? activeCat.getAttribute('data-cat') : 'personal';
    const emoji = activeCat ? activeCat.getAttribute('data-emoji') : '🎯';
    
    const activeTimeChip = document.querySelector('#preferredTimeChips .chip.active');
    const prefTime = activeTimeChip ? activeTimeChip.getAttribute('data-time') : '07:30 AM';
    
    const activeDurChip = document.querySelector('#durationChips .chip.active');
    const prefDur = activeDurChip ? parseInt(activeDurChip.getAttribute('data-dur'), 10) : 30;

    const mTitle = document.getElementById('inputMilestoneTitle').value.trim() || 'Foundational Milestone 1';
    const aTitle = document.getElementById('inputActionTitle').value.trim() || 'First actionable step';

    const newGoal = {
      id: `goal-${Date.now()}`,
      title,
      why: why || 'Make meaningful progress everyday.',
      category: category.charAt(0).toUpperCase() + category.slice(1),
      emoji,
      status: 'on-track',
      statusText: '● On Track',
      targetDate: '6 Months',
      routine: {
        frequency: '3x / week',
        days: 'Mon, Wed, Fri',
        time: `${prefTime} (${prefDur} min)`
      },
      milestones: [
        {
          id: `m-${Date.now()}`,
          title: mTitle,
          isCompleted: false,
          actions: [
            { id: `act-${Date.now()}`, title: aTitle, minutes: prefDur, time: prefTime, completed: false }
          ]
        }
      ]
    };

    state.goals.unshift(newGoal);
    closeSheets();
    renderDashboard();
  });

  // Submit Add Step
  document.getElementById('btnSubmitAddStep').addEventListener('click', () => {
    const stepTitle = document.getElementById('inputStepTitle').value.trim();
    const stepDuration = parseInt(document.getElementById('inputStepDuration').value, 10) || 30;
    if (!stepTitle || !state.activeMilestoneForStep) return;

    const goal = state.goals.find(g => g.id === state.selectedGoalId);
    if (goal) {
      const milestone = goal.milestones.find(m => m.id === state.activeMilestoneForStep);
      if (milestone) {
        milestone.actions.push({
          id: `act-${Date.now()}`,
          title: stepTitle,
          minutes: stepDuration,
          time: '08:00 AM',
          completed: false
        });
      }
    }

    closeSheets();
    renderGoalDetail(state.selectedGoalId);
  });

  // AI Reflection button
  const btnAiReflect = document.getElementById('btnAiReflect');
  if (btnAiReflect) {
    btnAiReflect.addEventListener('click', () => {
      btnAiReflect.textContent = 'Synthesizing...';
      btnAiReflect.disabled = true;

      setTimeout(() => {
        state.reflection.whatWentWell = 'Maintained high consistency with 16 actions logged. Key momentum was built on Master Conversational Spanish and Marathon Tempo Runs with peak execution in Health & Learning.';
        state.reflection.whatWasDifficult = 'Midweek fatigue made late evening SaaS deep work harder to start, causing slight friction in scheduled routines.';
        state.reflection.nextWeekFocus = 'Shift SaaS development to early Saturday morning, start Spanish conversational fluency sprint with tutor, and maintain tempo pace.';

        document.getElementById('txtWhatWentWell').value = state.reflection.whatWentWell;
        document.getElementById('txtWhatWasDifficult').value = state.reflection.whatWasDifficult;
        document.getElementById('txtNextWeekFocus').value = state.reflection.nextWeekFocus;

        const insightCard = document.getElementById('aiInsightCard');
        const insightText = document.getElementById('aiInsightText');
        if (insightCard && insightText) {
          insightCard.style.display = 'block';
          insightText.textContent = 'Your execution momentum is in the top tier (88% consistency). Prioritize conversational milestone depth over raw card volume next week.';
        }

        btnAiReflect.textContent = '✨ AI Reflect';
        btnAiReflect.disabled = false;
      }, 700);
    });
  }

  // Reflection auto-save
  const triggerAutoSave = () => {
    state.reflection.whatWentWell = document.getElementById('txtWhatWentWell').value;
    state.reflection.whatWasDifficult = document.getElementById('txtWhatWasDifficult').value;
    state.reflection.nextWeekFocus = document.getElementById('txtNextWeekFocus').value;
    
    const indicator = document.getElementById('savedIndicator');
    indicator.textContent = 'Saving...';
    setTimeout(() => {
      indicator.textContent = 'Auto-saved';
    }, 400);
  };

  document.getElementById('txtWhatWentWell').addEventListener('input', triggerAutoSave);
  document.getElementById('txtWhatWasDifficult').addEventListener('input', triggerAutoSave);
  document.getElementById('txtNextWeekFocus').addEventListener('input', triggerAutoSave);

  // Initial render
  renderDashboard();
});
