#ifndef ATM_EVENTS_HPP
#define ATM_EVENTS_HPP
#include <boost/msm/front/euml/euml.hpp>

namespace atm {
    
template<typename T>
struct event : boost::msm::front::euml::euml_event<T> { };

struct enter_card       : public event<enter_card> {};
struct enter_PIN        : public event<enter_PIN> {};
struct cash_collected   : public event<cash_collected> {};
struct card_taken       : public event<card_taken> {};
struct money_taken      : public event<money_taken> {};

} // namespace atm

#endif
