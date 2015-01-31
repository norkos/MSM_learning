#ifndef ATM_CONTROLER_HPP
#define ATM_CONTROLER_HPP

#include "events.hpp"
#include <boost/msm/front/state_machine_def.hpp>
#include <boost/msm/front/euml/euml.hpp>
#include <boost/msm/back/state_machine.hpp>

namespace mpl   = boost::mpl;
namespace front = boost::msm::front;
namespace back  = boost::msm::back;
namespace euml  = boost::msm::front::euml;

namespace atm {

class controller_ : public front::state_machine_def<controller_>
{
    struct idle             : front::state<>, euml::euml_state<idle> { };
    struct wait_for_pin     : front::state<>, euml::euml_state<wait_for_pin> { };
    struct collect_money    : front::state<>, euml::euml_state<collect_money> { };
    struct give_card        : front::state<>, euml::euml_state<give_card> { };
    struct give_money       : front::state<>, euml::euml_state<give_money> { };
    
public:
    
    typedef mpl::vector<idle> initial_state;
    
    BOOST_MSM_EUML_DECLARE_TRANSITION_TABLE((
        idle()            + enter_card()        == wait_for_pin()  ,
        wait_for_pin()    + enter_PIN()         == collect_money() ,
        collect_money()   + cash_collected()    == give_card()     ,
        give_card()       + card_taken()        == give_money()    ,
        give_money()      + money_taken()       == idle()
    ), transition_table)
    
};

typedef back::state_machine<controller_> controller;

} // namespace atm

#endif
